Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  root :to=>'admin/dashboard#index'
end
