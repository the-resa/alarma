Alarma::Application.routes.draw do
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
  # match ':controller(/:action(/:id(.:format)))'

  #/mapval/Mo/Sc/Y/M/all.Out
  match "/mapval/:model/:scenario/:year/:month/:var",
    :controller => :mapvals, :action => :index

  match "/mapdiff/:model/:scenario/:year_a/:month_a/:year_b/:month_b/:var",
    :controller => :mapdiff, :action => :index

  match "/propval/:model/:scenario/:year/:month/:var",
    :controller => :propval, :action => :index

  match "/propdiff/:model/:scenario/:year_a/:function_a/:year_b/:function_b/:var", :function_a => /min|max|avg|all/, :function_b => /min|max|avg|all/,
    :controller => :propdiff, :action => :index

  match "/propdiff/:model/:scenario/:year_a/:month_a/:year_b/:month_b/:var", :month_a => /\d+/, :month_b => /\d+/,
    :controller => :propdiff, :action => :index
end
