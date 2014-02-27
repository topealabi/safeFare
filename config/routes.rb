SafeFare::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users,:skip => [:sessions]
  as :user do
    get 'signin' => 'devise/sessions#new', :as => :new_user_session
    post 'signin' => 'devise/sessions#create', :as => :user_session
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end
#  ActiveAdmin.routes(self)
  resources :users do
    resources :restaurants do
     resources :type_of_cuisines
      resources :aware_employees do
        resources :restaurant_roles
      end
    end
  end

  resources :posts

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  match "/about" => "home#about", via: [:get, :post]
  match "/about/contact-us" => "home#contact", via: [:get]
  match "/submit" => "home#submit", via: [:post]
  match "/find-a-restaurant" => "search#index", via: [:get]
  match "/results" => "search#results", via: [:post, :get]
  match "/for-diners" => "home#for_diners", via: [:get]
  match "/for-restaurants" => "home#for_restaurants", via: [:get, :post]

  # devise_scope :user do
  #   get   '/for-restaurants',          to: 'devise/sessions#new'
  #   get   '/for-restaurants',          to: 'devise/sessions#new'
  #   get   'users/login',    to: 'devise/sessions#new'
  #   get   'logout',         to: 'devise/sessions#destroy'
  #   get   '/for-restaurants/signup',         to: 'devise/registrations#new'
  # end


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
