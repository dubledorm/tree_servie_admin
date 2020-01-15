class CreateTrees < ActiveRecord::Migration[6.0]
  def change
    create_table :trees do |t|
      t.references :instance, null: false
      t.string :name, null: false
      t.text :description

      t.timestamps

      t.index :name
      t.foreign_key :instances, column: :instance_id
    end
  end
end
