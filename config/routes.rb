Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  namespace 'api' do
    resources :instances, only: :show do
      resources :trees, only: [:show, :index, :create]
    end
  end

  root :to=>'admin/dashboard#index'
end
