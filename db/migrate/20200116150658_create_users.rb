class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.references :tree, null: false
      t.string :name, null: false
      t.string :ability, null: false
      t.timestamps
      t.foreign_key :trees, column: :tree_id
    end
  end
end
