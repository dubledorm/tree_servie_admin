class Instance < ApplicationRecord
  include CommonConcern

  INSTANCE_STATES = %w(new).freeze

  has_many :trees, dependent: :destroy
  has_many :nodes, through: :trees
  validates :state, presence: true, inclusion: { in: INSTANCE_STATES }
end
