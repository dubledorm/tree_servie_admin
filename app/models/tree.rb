class Tree < ApplicationRecord
  include CommonConcern

  belongs_to :instance
  has_many :nodes
  has_many :users

  validates :instance, presence: true
end
