#encoding: utf-8
#include Rails.application.routes.url_helpers #在console中调用orders_path等
Shopqi::Application.routes.draw do

  begin 'oauth2'
    get '/oauth/authorize'    , to: 'oauth#authorize'   , as: :authorize
    post '/oauth/access_token', to: 'oauth#access_token', as: :access_token
    match '/oauth/allow'      , to: 'oauth#allow'       , as: :oauth_allow
  end

  scope "/api" do # 供oauth2调用
    get '/me'            , to: 'shops#me'     , as: :api_me
    post '/themes/switch', to: 'themes#switch'
  end

  constraints(Domain::Theme) do # 主题商店
    scope module: :theme do
      get '/', to: 'themes#index', as: :theme_index
      scope "/themes" do
        get '/login'                                , to: 'themes#login'       , as: :theme_login
        get '/logout'                               , to: 'themes#logout'      , as: :theme_logout
        get '/get_shop'                             , to: 'themes#get_shop'    , as: :theme_get_shop
        post '/login/authenticate'                  , to: 'themes#authenticate', as: :theme_authenticate
        get '/filter'                               , to: 'themes#filter'
        get '/:handle/styles/:style_handle'         , to: 'themes#show'        , as: :theme
        get '/:handle/styles/:style_handle/download', to: 'themes#download'    , as: :theme_download
        match '/:handle/styles/:style_handle/apply' , to: 'themes#apply'
      end

      begin 'client' # 作为oauth client
        get '/callback', to: redirect('/themes/get_shop')
      end
    end
  end

  # 订单页面
  constraints(Domain::Checkout) do
    scope module: :shop do
      get '/carts/:shop_id/:cart_token'               , to: 'order#address'
      match '/carts/:shop_id/:cart_token/create_order', to: 'order#create'
      get '/orders/:shop_id/:token/pay'               , to: 'order#pay'    , as: :pay_order
      get '/orders/:shop_id/:token/forward'           , to: 'order#forward'    , as: :forward_order
      match '/orders/:shop_id/:token/commit'          , to: 'order#commit' , as: :commit_order
      post '/orders/notify'                     , to: 'order#notify', as: :notify_order
      post '/orders/:shop_id/:token/update_total_price', to: 'order#update_total_price', as: :update_order_total_price
      post '/carts/:shop_id/:cart_token/update_tax_price', to: 'order#update_tax_price', as: :update_order_tax_price
      get '/carts/:shop_id/:cart_token/get_address', to: 'order#get_address', as: :get_address
    end
  end

  ##### 商店及后台管理通用 #####
  match '/district/:id', to: 'district#list' # 地区选择(创建订单页面)
  #match '/s/files/:id/theme/assets/:asset', to: 'shops#asset', # :asset参数值为style.css(包含.号)，rspec报No route matches
  scope module: :shop do
    match '/s/files/:id/theme/:theme_id/assets/:file.:format'     , to: 'shops#asset'
    match '/s/files/test/:id/theme/:theme_id/assets/:file.:format', to: 'shops#asset' #测试中使用
  end

  constraints(Domain::Store) do

    devise_for :user, skip: :registrations, controllers: {sessions: "users/sessions"}# 登录

    scope module: :shop do # 前台商店
      scope '/account' do
        devise_for :customer do
          get '/login'                     , to: 'sessions#new'
          get '/signup'                    , to: 'registrations#new'
          get '/logout'                    , to: 'sessions#destroy'
        end
        get '/orders/:token'               , to: 'account#show_order' , as: :account_show_order
        get '/index'                       , to: 'account#index', as: :customer_account_index
        get '/'                            , to: 'account#index'
        resources :customer_addresses, path: '/addresses'
      end
      match '/'                            , to: 'shops#show'
      match '/password'                    , to: 'shops#password'
      get '/search'                        , to: 'search#show'
      get '/products/:handle'              , to: 'products#show', as: :product_show
      get '/collections'                   , to: 'collections#index'
      get '/collections/:handle'           , to: 'collections#show'
      get '/pages/:handle'                 , to: 'pages#show'
      post '/cart/add'                     , to: 'cart#add'
      get '/cart'                          , to: 'cart#show'
      post '/cart'                         , to: 'cart#update'
      get '/blogs/:handle/:id'             , to: 'articles#show'
      get '/blogs/:handle'                 , to: 'blogs#show'
      post '/articles/:article_id/comments', to: 'articles#add_comment'
    end

    scope "/admin" do # 用户后台管理

      match "/"                             , to: "home#dashboard"                      , as: :user_root # user_root_path为用户成功登录后的跳转地址
      match "/general_preferences"          , to: "shops#edit"
      match "/notifications"                , to: "emails#index"
      match "/notifications/subscribe"      , to: "emails#follow"
      match "/notifications/:id/unsubscribe", to: "emails#unfollow"                     , as: 'unfollow'
      match '/support'                      , to: redirect('http://support.shopqi.com/'), as: 'support'
      get '/lookup/query'                   , to: 'home#query'
      post "/dashboard/complete_task/:name" , to: "home#complete_task"                  , as: :complete_task
      post "/dashboard/launch"              , to: "home#launch"                         , as: :launch
      post "/dashboard/skip_tutorial"       , to: "home#skip_tutorial"                  , as: :skip_tutorial

      resources :shops, only: [:edit,:update]

      resources :payments

      scope "notifications" do
        resources :emails, only:[:index,:edit,:update]
      end

      resources :countries, only: [:create,:new,:edit,:index,:destroy,:update]

      resources :shipping, only: [:index]

      resources :weight_based_shipping_rates, only: [:edit,:update,:create,:destroy]
      resources :price_based_shipping_rates, only: [:edit,:update,:create,:destroy]

      resources :orders, only: [:index, :update, :show, :destroy] do
        collection do
          post :set
        end
        member do
          post :close  #关闭
          post :open   #重新打开
          post :cancel #取消
          post :previous #上一订单
          post :next     #下一订单
        end

        # 配送记录(物流信息)
        resources :fulfillments, except: [:index, :new, :create, :edit, :destroy] do
          collection do
            post :set
          end
        end

        # 支付记录
        resources :transactions
      end

      resources :customers, except: :edit do
        collection do
          get :search
        end
      end

      resources :customer_groups, only: [ :create, :update, :destroy ]

      resources :products, except: :edit do
        collection do
          get :inventory
          post :set
        end
        member do
          put :update_published
          post :duplicate
        end

        resources :photos, only:[:destroy,:new,:create] do
          collection do
            post :sort
          end
        end

        resources :product_variants, path: :variants, except: [:index, :new, :edit] do
          collection do
            post :sort
            post :set
          end
        end
      end

      resources :pages, except: :edit
      resources :articles

      resources :blogs do
        resources :articles
      end

      resources :comments, only: [:index,:destroy,:update] do
        member do
          post :spam
          post :approve
        end
        collection do
          post :set
        end
      end

      resources :users

      match 'account/change_plan/:code'      ,to: 'account#change_plan', as: :change_plan

      resources :account, only: [:index] do
        collection do
          post :change_ownership
          post :notify
          post :confirm_plan
        end
      end


      resources :link_lists, only: [:index, :create, :destroy, :update] do
        resources :links, only: [:create, :destroy] do
          collection do
            post :sort
          end
        end
      end

      resources :custom_collections, except: :edit do
        resources :custom_collection_products, path: :products, as: :products, except: [:index, :new, :edit, :update] do
          post :sort, on: :collection
        end
        collection do
          get :available_products
        end
        member do
          put :update_order
          put :update_published
        end
      end

      resources :smart_collections, except: [:index, :edit] do
        member do
          put :update_order
          put :update_published
          post :sort
        end
      end

      resources :domains, except: [:edit, :show] do
        member do
          get :check_dns
          put :make_primary
        end
      end

      resources :themes, only: [:index, :update, :destroy] do
        collection do
          post :upload     # 上传主题
        end
        member do
          post :duplicate  # 复制主题
          post :export     # 导出主题
          begin 'settings' # 外观设置
            get :settings      , to: 'shop_theme_settings#show'
            put :settings      , to: 'shop_theme_settings#update'
            post :delete_preset, to: 'shop_theme_settings#delete_preset'
          end
        end
        resources :assets do # 模板编辑器
          member do
            get :versions
            put :rename
            post :upload
          end
        end
      end

    end

  end

  scope module: :shopqi do # 官网
    root to: "home#page"
    get '/faq'       , to: 'home#faq'     , as: :faq
    scope "/tour" do # 功能演示
      get '/'        , to: 'home#tour'    , as: :tour_intro
      get '/store'   , to: 'home#store'   , as: :tour_store
      get '/design'  , to: 'home#design'  , as: :tour_design
      get '/security', to: 'home#security', as: :tour_security
      get '/features', to: 'home#features', as: :tour_features
    end
    get '/signup'         , to: redirect('/services/signup')
    get '/login'          , to: 'home#login'
    scope "/services/signup" do
      get '/'                    , to: 'home#signup'                               , as: :services_signup
      devise_scope :user do
        get "/new/:plan"         , to: "registrations#new"                         , as: :signup
        get "/check_availability", to: "registrations#check_availability"
        post "/user"             , to: "registrations#create"
        post "/verify_code"      , to: "registrations#verify_code" # 获取手机校验码
      end
    end
  end

  match '/media(/:dragonfly)', to: Dragonfly[:images]
  post '/kindeditor/upload_image'
end
