class Tree < ApplicationRecord
  include CommonConcern

  belongs_to :instance
  has_many :nodes

  validates :instance, presence: true
end
