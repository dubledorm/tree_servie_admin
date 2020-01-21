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
  has_many :tags
  has_many :user_nodes
  has_many :users, through: :user_nodes
  belongs_to :parent, class_name: 'Node', optional: true

  validates :tree, presence: true
  validates_with TheSameTree

  scope :tree_id, ->(tree_id){ where(tree_id: tree_id) }
  scope :parent_id, ->(parent_id){ where(parent_id: parent_id) }
end
