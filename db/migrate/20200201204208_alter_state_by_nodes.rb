class AlterStateByNodes < ActiveRecord::Migration[6.0]
  def up

    Node.all.each do |node|
      node.state = 'active'
      node.save
    end
    change_column :nodes, :state, :string, null: false
  end

  def down
    change_column :nodes, :state, :string, null: true
  end
end
