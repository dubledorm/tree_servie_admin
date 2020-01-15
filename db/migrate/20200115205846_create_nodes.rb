class CreateNodes < ActiveRecord::Migration[6.0]
  def change
    create_table :nodes do |t|
      t.references :tree, null: false
      t.references :parent
      t.string :name
      t.text :description
      t.string :node_type
      t.string :node_subtype

      t.timestamps
      t.foreign_key :trees, column: :tree_id
      t.foreign_key :nodes, column: :parent_id
    end
  end
end
