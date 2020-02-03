class TheSameUserNodeTree < ActiveModel::Validator
  def validate(record)
    return if record.user_id.nil? || record.node_id.nil?

    user = User.find(record.user_id)
    node = Node.find(record.node_id)

    record.errors[:user_id] << 'could not find user with id = ' + record.user_id.to_s if user.nil?
    record.errors[:node_id] << 'could not find node with id = ' + record.node_id.to_s if node.nil?

    return if user.nil? || node.nil?

    record.errors[:user_id] << 'user should be the same tree as the node' unless user.tree == node.tree
  end
end

class UserNode < ApplicationRecord
  belongs_to :user
  belongs_to :node

  validates :user, :node, presence: true
  validates_with TheSameUserNodeTree
end
