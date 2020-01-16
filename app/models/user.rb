class User < ApplicationRecord
  include CommonConcern

  belongs_to :tree

  validates :ability, :tree, presence: true
end
