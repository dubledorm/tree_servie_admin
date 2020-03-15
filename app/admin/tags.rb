ActiveAdmin.register Tag do
  permit_params :node_id, :name, :value_type, :value_string, :value_int
end
