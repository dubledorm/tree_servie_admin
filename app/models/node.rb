class Node < ApplicationRecord
  belongs_to :tree
  has_one :instance, through: :tree
  has_many :tags
  has_many :user_nodes
  has_many :users, through: :user_nodes
  belongs_to :parent, class_name: 'Node', optional: true

  validates :tree, presence: true
end
