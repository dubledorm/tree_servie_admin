class AddStateToNodes < ActiveRecord::Migration[6.0]
  def change
    add_column :nodes, :state, :string

    add_index :nodes, :state
  end
end
