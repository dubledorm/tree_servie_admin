class CreateInstances < ActiveRecord::Migration[6.0]
  def change
    create_table :instances do |t|
      t.string :name, null: false, uniq: true
      t.text :description
      t.string :state, null: false

      t.timestamps
    end

    add_index :instances, :name
  end
end
