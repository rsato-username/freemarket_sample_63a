class Item < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many_attached :images
  

  def self.search(search)
    if search
      Item.where(['name LIKE ?', "%#{search}%"])
    else
      Item.all
    end
  end

  def previous
    Item.where("id < ?", self.id).order("id DESC").first
  end

  def next
    Item.where("id > ?", self.id).order("id ASC").first
  end
end
