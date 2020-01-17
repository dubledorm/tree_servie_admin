ActiveAdmin.register User do
  permit_params :name, :description, :instance_id
end
