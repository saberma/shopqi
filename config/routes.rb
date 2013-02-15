#encoding: utf-8
#include Rails.application.routes.url_helpers #在console中调用orders_path等
Shopqi::Application.routes.draw do

  mount Doorkeeper::Engine => '/oauth'

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      get '/shop'           , to: "shops#show"
      post '/themes/install', to: 'themes#install'
      get '/products'       , to: "products#index"
      get '/products/:id'   , to: "products#show"
      put '/variants/:id'   , to: "product_variants#update"
      get '/orders'         , to: "orders#index"
      get '/orders/:id'     , to: "orders#show"
      post '/webhooks'      , to: "webhooks#create"
    end
  end

  constraints(Domain::Wiki) do # 帮助文档
    devise_for :admin_users, ActiveAdmin::Devise.config
    scope module: :wiki do
      get '/'                         , to: 'wiki_pages#index'           , as: :wiki_pages_index
      get '/active_admin'             , to: redirect('/')
      resources :wiki_pages           , only:[:new                       , :create]
      get '/pages'                    , to: 'wiki_pages#pages'           , as: :wiki_pages_all
      match '/search'                 , to: 'wiki_pages#search'
      get '/history/:name'            , to: 'wiki_pages#history'
      get '/robots.txt'               , to: 'wiki_pages#robots'
      get '/:name'                    , to: 'wiki_pages#show'
      post '/destroy/:name'           , to: 'wiki_pages#destroy'
      get '/edit/:name'               , to: 'wiki_pages#edit'
      post '/compare/:name'           , to: 'wiki_pages#compare'
      get '/compare/:name/:sha1/:sha2', to: 'wiki_pages#compare_versions'
      post '/revert/:name/:sha1/:sha2', to: 'wiki_pages#revert'
      get '/:name/:sha'               , to: 'wiki_pages#show'
      post '/update'                  , to: 'wiki_pages#update'          , as: :update_page
      post '/preview'                 , to: 'wiki_pages#preview'
    end
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
      get '/robots.txt'                             , to: 'themes#robots'

      begin 'client' # 作为oauth client
        get '/callback', to: redirect('/themes/get_shop')
      end
    end
  end

  ##### 商店及后台管理通用 #####
  match '/district/:id', to: 'district#list' # 地区选择(创建订单页面)
  scope module: :shop do
    match '/s/files/:id/theme/:theme_id/assets/:file.:format'            , to: 'shops#asset', file: /.+/
    match '/s/files/development/:id/theme/:theme_id/assets/:file.:format', to: 'shops#asset', file: /.+/ #开发中使用
    match '/s/files/test/:id/theme/:theme_id/assets/:file.:format'       , to: 'shops#asset', file: /.+/ #测试中使用
  end

  constraints(Domain::Shopqi) do
    scope module: :shopqi do # 官网
      root to: "home#page"
      get '/faq'       , to: 'home#faq'     , as: :faq
      get '/links'     , to: 'home#links'   , as: :home_links
      get '/about'     , to: 'home#about'   , as: :about
      scope "/tour" do # 功能演示
        get '/'        , to: 'home#tour'    , as: :tour_intro
        get '/store'   , to: 'home#store'   , as: :tour_store
        get '/design'  , to: 'home#design'  , as: :tour_design
        get '/security', to: 'home#security', as: :tour_security
        get '/features', to: 'home#features', as: :tour_features
      end
      get '/agreement', to: 'home#agreement'            , as: :agreement
      get '/signup'   , to: redirect('/services/signup')
      get '/login'    , to: 'home#login'
      scope "/services/signup" do
        # :confirmations, :omniauth_callbacks, :passwords, :registrations, :sessions, :unlocks
        devise_for :user, skip: [:sessions, :confirmations, :passwords], skip_helpers: true
        devise_scope :user do
          get '/new/professional'  , to: 'registrations#new'                         , as: :services_signup
          get "/new/:plan"         , to: "registrations#new"                         , as: :signup
          get "/check_availability", to: "registrations#check_availability"
          post "/user"             , to: "registrations#create"                      , as: :signup_user
          post "/verify_code"      , to: "registrations#verify_code" # 获取手机校验码
        end
      end
      get '/robots.txt', to: 'home#robots'
    end

    #官网后台管理
    ActiveAdmin.routes(self)
    authenticate :admin_user do # 管理员权限
      mount Resque::Server.new, at: "/resque" # 查看后台任务执行情况
    end

    devise_for :admin_users, ActiveAdmin::Devise.config
  end

  constraints(Domain::Store) do

    devise_for :user, skip: :registrations, controllers: {sessions: "admin/sessions"} # 登录

    scope module: :shop do # 前台商店
      scope '/account' do
        devise_for :customer, only: :passwords
        devise_scope :customer do
          get '/login'                     , to: 'sessions#new'        , as: :new_customer_session
          post '/login'                    , to: 'sessions#create'
          get '/logout'                    , to: 'sessions#destroy'
          get '/signup'                    , to: 'registrations#new'   , as: :new_customer_registration
          post '/customer'                 , to: 'registrations#create', as: :customer_registration
        end
        get '/orders/:token'               , to: 'account#show_order', as: :account_show_order
        get '/index'                       , to: 'account#index'     , as: :customer_root
        get '/'                            , to: 'account#index'
        resources :customer_addresses      , path: '/addresses'
      end
      match '/'                                             , to: 'shops#show'
      match '/password'                                     , to: 'shops#password'
      get   '/unavailable'                                  , to: 'shops#unavailable'
      get '/themes'                                         , to: 'shops#themes'        , as: :shop_themes_tip
      get '/search'                                         , to: 'search#show'
      get '/products/:handle'                               , to: 'products#show'       , as: :product_show
      get '/collections/:collection_handle/products/:handle', to: 'products#show'       , as: :collection_product_show
      get '/collections'                                    , to: 'collections#index'
      get '/products'                                       , to: 'collections#index'   , as: :shop_products
      get '/collections/all'                                , to: 'collections#show_all'
      get '/collections/:handle/products'                   , to: 'collections#show'
      get '/collections/:handle'                            , to: 'collections#show_with_types_or_vendors' , constraints: { handle: /types|vendors/ }
      get '/collections/:handle/:tags'                      , to: 'collections#show_with_tag'
      get '/collections/:handle'                            , to: 'collections#show'
      get '/pages/:handle'                                  , to: 'pages#show'
      post '/cart/add'                                      , to: 'cart#add'
      get '/cart'                                           , to: 'cart#show'
      post '/cart'                                          , to: 'cart#update'
      get '/cart/change/:variant_id'                        , to: 'cart#change'
      post '/cart/change'                                   , to: 'cart#change'
      post '/cart/clear'                                    , to: 'cart#clear'
      begin 'checkout' # 结算
        get '/carts/:cart_token'                            , to: 'order#new'
        get '/carts/:cart_token/shipping_rates/:code'       , to: 'order#shipping_rates'
        get '/carts/:cart_token/get_address'                , to: 'order#get_address'       , as: :get_address
        post '/carts/:cart_token/apply_discount'            , to: 'order#apply_discount'
        post '/carts/:cart_token'                           , to: 'order#create'
        post '/orders/notify'                               , to: 'order#notify'            , as: :notify_order
        get '/orders/done'                                  , to: 'order#done'              , as: :done_order
        match '/orders/tenpay_notify'                       , to: 'order#tenpay_notify'     , as: :tenpay_notify_order
        get '/orders/tenpay_done/:token'                    , to: 'order#tenpay_done'       , as: :tenpay_done_order
        get '/orders/:token'                                , to: 'order#show'              , as: :shop_order
      end
      get '/blogs/:handle'                                  , to: 'blogs#show'
      get '/blogs/:handle/:id'                              , to: 'articles#show'
      match '/blogs/:handle/:id/comments'                   , to: 'articles#add_comment'
      post '/contact'                                       , to: 'contact#create'
      get '/robots.txt'                                     , to: 'shops#robots'
    end

    scope module: :admin do # 用户后台管理(无 /admin 前缀)
      post '/kindeditor/upload_image', to: 'kindeditor#upload_image'
    end

    scope "/admin", module: :admin do # 用户后台管理
      match "/"                             , to: "home#dashboard"                      , as: :user_root # user_root_path为用户成功登录后的跳转地址
      get '/message'                        , to: "home#message"                        , as: :home_message

      resources :api_clients

      match "/general_preferences"          , to: "shops#edit"
      match "/notifications"                , to: "emails#index"
      match "/notifications/subscribe"      , to: "emails#follow"
      match "/notifications/:id/unsubscribe", to: "emails#unfollow"                     , as: 'unfollow'
      match "/notifications/preview_:view_type"   , to: 'emails#preview'
      match '/support'                      , to: redirect('http://support.shopqi.com/'), as: 'support'
      get '/lookup/query'                   , to: 'home#query'
      post "/dashboard/complete_task/:name" , to: "home#complete_task"                  , as: :complete_task
      post "/dashboard/launch"              , to: "home#launch"                         , as: :launch
      post "/dashboard/skip_tutorial"       , to: "home#skip_tutorial"                  , as: :skip_tutorial

      resources :webhooks, only: [:create, :destroy]

      resources :shops, only: [:update]

      resources :payments

      scope "notifications" do
        resources :emails, only:[:index,:edit,:update]
      end

      resources :countries, only: [:create,:new,:edit,:index,:destroy,:update]

      resources :shippings, only: [:index, :create, :destroy] do
        resources :weight_based_shipping_rates, only: [:edit,:update,:create,:destroy]
        resources :price_based_shipping_rates, only: [:edit,:update,:create,:destroy]
      end

      resources :orders, only: [:index, :update, :show, :destroy] do
        collection do
          post :set
        end
        member do
          post :close  #关闭
          post :open   #重新打开
          put  :cancel #取消
          post :previous #上一订单
          post :next     #下一订单
          post :alipay_refund_notify, as: :alipay_refund_notify  #支付宝退款通知
        end

        # 配送记录(物流信息)
        resources :fulfillments, except: [:index, :new, :create, :edit, :destroy] do
          collection do
            post :set
          end
        end

        resources :transactions # 支付记录
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

        resources :product_options, only: [] do # 商品选项
          member do
            post :move
          end
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

      resources :users do
        member do
          put :update_permissions
        end
      end

      resources :account, only: [:index] do
        collection do
          get 'change_plan/:code', to: 'account#change_plan', as: :change_plan
          post :confirm_plan
          get  :pay_plan
          post :confirm_pay_plan
          post :change_ownership
          post :notify
          get  :cancel
          delete :destroy
          get :done
        end
      end


      resources :link_lists, only: [:index, :create, :destroy, :update] do
        resources :links, only: [:create, :destroy] do
          collection do
            post :sort
          end
        end
      end
      get '/links' => redirect('/admin/link_lists') # 商店模板中使用

      resources :discounts, only: [:index, :create, :destroy]

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
          get  :current    # 当前主题的模板编辑器
          get  :settings   # 当前主题的外观设置
          get  '/current/settings', to: 'themes#settings'
        end
        member do
          get  :background_queue_status  # 检查主题解压状态
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

  match '/media(/:dragonfly)', to: Dragonfly[:images]

  constraints(Domain::NoStore) do
    scope module: :shopqi do # 用于处理商店不存在的情况
      match '/favicon.ico'     , to: 'home#favicon'
      match '/'                , to: 'home#no_shop'
      match '/*any'            , to: 'home#no_shop'
    end
  end

  constraints(Domain::Store) do
    scope module: :shop do # 前台商店
      match '/favicon.ico'                 , to: 'shops#favicon'
      match '/:unkown'                     , to: 'shops#unkown' # 访问商店不存在的页面时显示404，一定要放在route最后面
    end
  end

  constraints(Domain::Shopqi) do
    scope module: :shopqi do
      match '/*any'   ,to: "home#no_page"
    end
  end

end
