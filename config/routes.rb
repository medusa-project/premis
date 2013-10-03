Premis::Application.routes.draw do

  # Must be before Blacklight.add_routes... This stmt makes sure we can have periods (& :-) in ids
  resources :catalog, constraints: {id: /[A-Z,a-z0-9\.\:\-]+?/, format: /html|json|xml|rss|atom/}

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  devise_for :users
  root :to => "catalog#index"

  # use for back to search when in editing mode
  get 'medusa_premis', to: 'catalog#index'

  namespace :medusa_premis do
    resources :agents, constraints: {id: /[A-Z,a-z0-9\.\:\-]+?/, format: /html|json|xml|rss|atom/}
    resources :rights_statements, constraints: {id: /[A-Z,a-z0-9\.\:\-]+?/, format: /html|json|xml|rss|atom/}, :only => [:new, :create, :update, :edit, :destroy]
    resources :events, constraints: {id: /[A-Z,a-z0-9\.\:\-]+?/, format: /html|json|xml|rss|atom/}
    resources :representation_objects, constraints: {id: /[A-Z,a-z0-9\.\:\-]+?/, format: /html|json|xml|rss|atom/}
    resources :file_objects, constraints: {id: /[A-Z,a-z0-9\.\:\-]+?/, format: /html|json|xml|rss|atom/}
    resources :advanced, constraints: {id: /[A-Z,a-z0-9\.\:\-]+?/, format: /html|json|xml|rss|atom/}
    # match 'file_objects/:id/show_object' => 'file_objects#show_object', constraints: {id: /[A-Z,a-z0-9\.\:\-]+?/, format: /html|json|xml|rss|atom/}
    get 'file_objects/:id/show_object', to: 'file_objects#show_object', :as => 'show_object', constraints: {id: /[A-Z,a-z0-9\.\:\-]+?/, format: /html|json|xml|rss|atom/}
  end




  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

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
  #       get 'recent', :on => :collection
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
