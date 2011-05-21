Shopqi::Application.routes.draw do

  devise_for :user, controllers: {registrations: "users/registrations"} do
    get "signup", to: "users/registrations#new"
    get "login", to: "devise/sessions#new"
  end


  constraints(Subdomain) do
    match '/' => 'home#dashboard'
  end

  match "/admin" => "home#dashboard"

  scope "/admin" do

    resources :products, except: :edit do
      collection do
        get :inventory
        post :set
      end
      member do
        put :update_published
        post :duplicate
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
