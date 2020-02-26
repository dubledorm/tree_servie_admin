class Tag < ApplicationRecord
  include CommonConcern

  TAG_VALUE_TYPES = %w(int string).freeze

  belongs_to :node
  has_one :tree, through: :node
  has_one :instance, through: :tree

  validates :name, uniqueness: { scope: :node }
  validates :value_type, presence: true, inclusion: { in: TAG_VALUE_TYPES }

  scope :node_id, ->(node_id){ where(node_id: node_id) }
  scope :tree_id, ->(tree_id){ joins(:node).where(nodes: { tree_id: tree_id }) }
  scope :instance_id, ->(instance_id){ joins(:node).joins(:instance).where(nodes: { trees: { instance_id: instance_id } }) }
  scope :by_string_value, ->(name, value){ where(name: name, value_string: value, value_type: 'string') }
  scope :by_int_value, ->(name, value){ where(name: name, value_int: value, value_type: 'int') }
end
