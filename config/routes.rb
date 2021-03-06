Rails.application.routes.draw do

  

  resources :odgovors
  resources :questions
  get 'sessions/new'
  get 'users/edit'
  get 'quizzes/start'
  get 'quizzes/kraj'
  
  
  post 'quizzes/start' => 'quizzes#start'
  get 'quizzes/rnglist' => 'quizzes#rnglist'
  get 'quizzes/rezultat' => 'quizzes#rezultat'
  get 'quizzes/prepare_quiz' => 'quizzes#prepare_quiz'
  
=begin
  root 'stranice#home'
  get  'stranice/help'
  get  'stranice/about'
  get  'stranice/contact'
=end

Rails.application.routes.draw do
  resources :odgovors
  resources :questions
  get 'sessions/new'

  get 'users/new'
  get 'myquizzes' => 'quizzes#mykvizes'
  post 'myquizzes' => 'quizzes#mykvizes'
  
  get 'dodajpitanje' => 'questions#dodajpitanje'
  root             'stranice#home'
  get 'help'    => 'stranice#help'
  get 'about'   => 'stranice#about'
  get 'contact' => 'stranice#contact'
  get 'singup'  => 'users#new'
  
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  resources :quizzes
  resources :users
end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'stranice#home'

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
