class Photo < ApplicationRecord
  belongs_to :item, optional: true
  mount_uploader :url, ImageUploader
  # attr_accessor :url_cache, :remove_url
  
end
