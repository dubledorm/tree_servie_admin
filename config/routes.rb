Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  namespace 'api' do
    resources :instances, only: :show do
      resources :trees, only: [:show, :index, :create] do
        resources :nodes do
          member do
            get :children
          end
        end
      end
    end
  end

  root :to=>'admin/dashboard#index'
end
