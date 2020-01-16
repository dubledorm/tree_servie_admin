class CreateUserNodes < ActiveRecord::Migration[6.0]
  def change
    create_table :user_nodes do |t|
      t.references :user, null: false
      t.references :node, null: false

      t.timestamps
      t.foreign_key :users, column: :user_id
      t.foreign_key :nodes, column: :node_id
    end
  end
end
