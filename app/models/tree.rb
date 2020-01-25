class Tree < ApplicationRecord
  include CommonConcern

  belongs_to :instance
  has_many :nodes
  has_many :users

  validates :instance, presence: true
  validates :name, uniqueness: { scope: :instance }

  scope :instance_id, ->(instance_id){ where(instance_id: instance_id) }
end
