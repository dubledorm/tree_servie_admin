ActiveAdmin.register Instance do
  permit_params :name, :description, :state
end
