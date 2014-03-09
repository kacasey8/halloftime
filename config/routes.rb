HallOfTime::Application.routes.draw do

  get "pages/dashboard"
  get "pages/about"
  get "user/index", as: :users
  match "user/approve_account/:id", to: "user#approve_account", via: :get, as: :users_approve
  match "user/promote/:id", to: "user#promote", via: :get, as: :users_promote
  match "user/destroy/:id", to: "user#destroy", via: :get, as: :users_destroy
  match "user/set_current_task", to: "user#set_current_task", via: :get, as: :users_current_task
  match "user/complete_current_task", to: "user#complete_current_task", via: :get, as: :users_complete_task
  match "user/:id", to: "user#show", via: :get, as: :user
  match "user_with_tasks/:id", to: "user#tasks", via: :get, as: :tasks_for_user
  match "user_with_tasks/:id", to: "user#set_tasks", via: :post, as: :set_tasks_for_user
  resources :projects
  root to: "pages#dashboard"

  resources :tasks

  devise_for :users
  #root to: "users"
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
