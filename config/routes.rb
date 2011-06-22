#encoding: utf-8
#include Rails.application.routes.url_helpers #在console中调用orders_path等
Shopqi::Application.routes.draw do

  devise_for :user, controllers: {registrations: "users/registrations"} do
    get "signup", to: "users/registrations#new"
    get "login", to: "devise/sessions#new"
  end


  # 前台商店
  constraints(Subdomain) do
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

  scope "/admin" do

    resources :shops, only: [:edit,:update]

    scope "notifications" do
      resources :emails
    end

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

    resources :blogs do
      resources :articles
    end

    resources :users

    resources :account, only: [:index] do
      collection do
        post :change_ownership
      end
    end

    resources :comments

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

    resources :themes

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
