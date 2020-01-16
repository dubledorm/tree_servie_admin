class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.references :node, null: false
      t.string :name, null: false
      t.string :value_type, null: false
      t.text :value_string
      t.integer :value_int

      t.timestamps
      t.foreign_key :nodes, column: :node_id
      t.index :name
    end
  end
end
