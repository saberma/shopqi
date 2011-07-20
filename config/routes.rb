#encoding: utf-8
#include Rails.application.routes.url_helpers #在console中调用orders_path等
Shopqi::Application.routes.draw do

  begin 'oauth2'
    get '/oauth/authorize'    , :to => 'oauth#authorize'   , :as => :authorize
    post '/oauth/access_token', :to => 'oauth#access_token', :as => :access_token
    match '/oauth/allow'      , :to => 'oauth#allow'       , :as => :oauth_allow
  end

  scope "/api" do # 供oauth2调用
    get '/me' => 'shops#me'                 , as: :api_me
    post '/themes/switch' => 'themes#switch'
  end

  devise_for :user, controllers: {registrations: "users/registrations"} do
    get "signup", to: "users/registrations#new"
    get "login", to: "devise/sessions#new"
  end

  constraints(subdomain: 'themes') do # 主题商店 
    scope module: :theme do
      get '/' => 'themes#index', as: :theme_index
      scope "/themes" do
        get '/login' => 'themes#login'                          , as: :theme_login
        get '/logout' => 'themes#logout'                        , as: :theme_logout
        get '/get_shop' => 'themes#get_shop'                    , as: :theme_get_shop
        post '/login/authenticate' => 'themes#authenticate'     , as: :theme_authenticate
        get '/filter' => 'themes#filter'
        get '/:name/styles/:style' => 'themes#show'             , as: :theme
        get '/:name/styles/:style/download' => 'themes#download', as: :theme_download
        match '/:name/styles/:style/apply' => 'themes#apply'
      end

      begin 'client' # 作为oauth client
        get '/callback' => redirect('/themes/get_shop')
      end
    end
  end

  constraints(Subdomain) do # 前台商店
    #match '/' => 'home#dashboard'
    scope module: :shop do
      match '/' => 'shops#show'
      get '/search' => 'search#show'
      get '/products/:handle' => 'products#show'
      get '/collections/all' => 'collections#show'
      get '/pages/:handle' => 'pages#show'
      post '/cart/add' => 'cart#add'
      get '/cart' => 'cart#show'
      post '/cart' => 'cart#update'
      get '/blogs/:handle/:id' => 'articles#show'
      post '/articles/:article_id/comments' => 'articles#add_comment'
    end
  end

  # 订单页面
  constraints(subdomain: 'checkout') do
    scope module: :shop do
      get '/carts/:shop_id/:cart_token' => 'order#address'
      match '/carts/:shop_id/:cart_token/create_order' => 'order#create'
      get '/orders/:shop_id/:token/pay' => 'order#pay', as: :pay_order
      match '/orders/:shop_id/:token/commit' => 'order#commit', as: :commit_order
    end
  end

  ##### 商店及后台管理通用 #####
  match '/district/:id' => 'district#list' # 地区选择(创建订单页面)
  #match '/s/files/:id/theme/assets/:asset' => 'shops#asset', # :asset参数值为style.css(包含.号)，rspec报No route matches
  scope module: :shop do
    match '/s/files/:id/theme/assets/:file.:format' => 'shops#asset'
    match '/s/files/test/:id/theme/assets/:file.:format' => 'shops#asset' #测试中使用
  end

  match "/admin" => "home#dashboard"
  match "/admin/general_preferences" => "shops#edit"
  match "/admin/notifications" => "emails#index"
  match "/admin/notifications/subscribe" => "emails#follow"
  match "/admin/notifications/:id/unsubscribe" => "emails#unfollow", as: 'unfollow'
  match '/admin/lookup/query' => 'home#query', via: :get
  match '/admin/support' => redirect('http://support.shopqi.com/'), as: 'support'


  scope "/admin" do

    resources :shops, only: [:edit,:update]

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

      resources :photos,only:[:destroy,:new,:create] do
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
    resources :articles, only: [:new,:create]

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

    resources :account, only: [:index] do
      collection do
        post :change_ownership
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

    begin :themes
      get 'themes/settings' => 'themes#settings', as: :settings_themes
      put 'themes/settings' => 'themes#update'
      post 'themes/delete_preset' => 'themes#delete_preset'
    end
    scope 'themes' do
      resources :assets do
        member do
          get :versions
          put :rename
          post :upload
        end
      end
    end

  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  # This route can be invoked with purchase_url(id: product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root to: "home#dashboard"

  match '/media(/:dragonfly)', to: Dragonfly[:images]
  post '/kindeditor/upload_image'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
