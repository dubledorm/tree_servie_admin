Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  namespace 'api' do
    resources :instances, only: :show do
      resources :trees do
        resources :users, only: [:show, :create, :update, :destroy]
        resources :user_nodes, only: [:create, :destroy]
        resources :nodes do
          resources :tags
          member do
            get :children
            get :path_to_root
            get :all_children
            get :count_children
            get :count_all_children
          end

          collection do
            get :root
            get :count
          end
        end
      end
    end
  end

  root :to=>'admin/dashboard#index'
end
