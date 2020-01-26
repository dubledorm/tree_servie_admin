class Tree < ApplicationRecord
  include CommonConcern

  belongs_to :instance
  has_many :nodes, dependent: :destroy
  has_many :users, dependent: :destroy

  validates :instance, presence: true
  validates :name, uniqueness: { scope: :instance }

  scope :instance_id, ->(instance_id){ where(instance_id: instance_id) }
end
