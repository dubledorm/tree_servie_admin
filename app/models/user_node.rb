class UserNode < ApplicationRecord
  belongs_to :user
  belongs_to :node

  validates :user, :node, presence: true
end
