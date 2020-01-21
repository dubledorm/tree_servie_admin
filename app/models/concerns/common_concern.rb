# encoding: UTF-8
module CommonConcern
  extend ActiveSupport::Concern

  REGEXP_FOR_NAME = /\A[a-zA-Z][a-zA-Z\d\._]+\z/

  included do
    validates :name, presence: true, format: { with: /\A[a-zA-Z][a-zA-Z\d\._]+\z/}
  end
end
