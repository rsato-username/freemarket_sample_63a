class Item < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many   :photos
  accepts_nested_attributes_for :photos, allow_destroy: true
end
