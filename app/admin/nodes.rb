ActiveAdmin.register Node do
  permit_params :name, :tree_id, :parent_id, :description, :node_type, :node_subtype, :state
end
