Social::Application.routes.draw do
 
  resources :streams do 
    member do
      post 'reply'
      post 'follow'
    end
  end

  mount Ckeditor::Engine => '/ckeditor'
  devise_for :clients do
    get 'home', :to => 'dashboard#index', :as => :clients_root
  end
  
  resources :clients
  resources :tweets do
    
    get :reset_filterrific, :on => :collection
    member do
      post 'reply'
      put 'rate'
      put 'reset'
    end
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :keywords

  resources :posts do 
    post :publish
    post :update
  end
  
  post '/posts/:id/' , to: 'posts#update'
  
  resources  :accounts do
    post :make_primary
  end
  get '/auth/:provider/callback', to: 'accounts#create'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'dashboard#welcome'
  
  delete 'disconnect_twitter' => "twitter_access#disconnect_twitter"
  get 'oauth_account' => "twitter_access#oauth_account"
  get 'twitter_oauth_url' => 'twitter_access#generate_twitter_oauth_url'
  get 'follow' => "twitter_access#follow"
  post 'retweet' => "twitter_access#retweet"
 
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
