Rails.application.routes.draw do
  
    devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",:sessions=>"users/sessions"}
    # Slack auth callback
    get 'oauth/authorize'=>"profiles#index"
        
    devise_scope :user do
        get '/users/auth/:provider/callback' => 'users/omniauth_callbacks#google_oauth2'
        get 'auth_profile'=> "users/omniauth_callbacks#authorize"    
        get 'signin' => 'users/sessions#new' #, :as => :new_user_session
        post 'signin' => 'users/sessions#create' #, :as => :user_session
        delete 'signout' => 'users/sessions#destroy'
        authenticated :user do
            root to: "home#index",:as=>:authenticated_root
        end

        unauthenticated do
            root "users/sessions#new"
        end

        resources :home do
            collection do
                get :load_profile 
                post :get_profile_metrics
                post :send_daily_summary
            end 
        end
        resources :profiles,:only=>[:edit,:update,:index]
        resources :mywebsite, :path => 'w'
        mount Resque::Server, :at => "/resque"
    end    
    
    
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
