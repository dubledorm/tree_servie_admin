class User < ApplicationRecord
  include CommonConcern

  ABILITY_VALUES = %w(all read write_tag).freeze

  belongs_to :tree
  has_one :instance, through: :tree
  has_many :user_nodes, dependent: :destroy
  has_many :nodes, through: :user_nodes

  validates :ability, :tree, presence: true
  validates :ability, inclusion: { in: ABILITY_VALUES }
  validates :name, uniqueness: { scope: :tree }

  scope :instance_id, ->(instance_id){ joins(:tree).where(trees: { instance_id: instance_id }) }
  scope :tree_id, ->(tree_id){ where(tree_id: tree_id) }

end
