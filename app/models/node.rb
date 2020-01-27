class TheSameTree < ActiveModel::Validator
  def validate(record)
    unless record.parent_id.nil?
      parent = Node.find(record.parent_id)
      if parent.nil?  # Если ошибка в переданном parent_id - такого не существует
        record.errors[:parent_id] << 'could not find node with id = ' + record.parent_id.to_s
        return
      end
      if parent.tree_id != record.tree_id # если parent принадлежит к другому дереву
        record.errors[:parent_id] << 'parent_id should be the same tree as the node'
      end
    end
  end
end

class Node < ApplicationRecord
  belongs_to :tree
  has_one :instance, through: :tree
  has_many :tags, dependent: :destroy
  has_many :user_nodes, dependent: :destroy
  has_many :users, through: :user_nodes
  belongs_to :parent, class_name: 'Node', optional: true
  has_many :children, class_name: 'Node', foreign_key: 'parent_id', dependent: :destroy

  validates :tree, presence: true
  validates_with TheSameTree

  scope :instance_id, ->(instance_id){ joins(:tree).where(trees: { instance_id: instance_id }) }
  scope :tree_id, ->(tree_id){ where(tree_id: tree_id) }
  scope :parent_id, ->(parent_id){ where(parent_id: parent_id) }
  scope :node_type_value, ->(node_type_value){ where(node_type: node_type_value) }
  scope :node_subtype_value, ->(node_subtype_value){ where(node_subtype: node_subtype_value) }
  scope :user_id, ->(user_id){ joins(:user_nodes).where(user_nodes: { user_id: user_id }) }
end
