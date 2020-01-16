class User < ApplicationRecord
  include CommonConcern

  belongs_to :tree
  has_many :user_nodes
  has_many :nodes, through: :user_nodes

  validates :ability, :tree, presence: true
end
