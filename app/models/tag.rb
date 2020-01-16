class Tag < ApplicationRecord
  include CommonConcern

  TAG_VALUE_TYPES = %w(int string).freeze

  belongs_to :node

  validates :value_type, presence: true, inclusion: { in: TAG_VALUE_TYPES }
end
