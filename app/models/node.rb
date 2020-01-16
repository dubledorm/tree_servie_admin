class Node < ApplicationRecord
  belongs_to :tree
  has_one :instance, through: :tree
  has_many :tags
  belongs_to :parent, class_name: 'Node', optional: true

  validates :tree, presence: true
end
