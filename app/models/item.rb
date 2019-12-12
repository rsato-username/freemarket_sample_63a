class Item < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :brand, optional: true
  has_many   :photos,  foreign_key: :item_id, dependent: :destroy
  accepts_nested_attributes_for :brand, reject_if: :reject_both_blank
  accepts_nested_attributes_for :photos, allow_destroy: true

  

  def self.search(search)
    if search
      Item.where(['name LIKE ?', "%#{search}%"])
      Item.where(['description LIKE ?', "%#{search}%"])
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

  def reject_both_blank(attributes)
    if attributes[:id]
      attributes.merge!(_destroy: "1") if attributes[:name].blank?
      !attributes[:name].blank?
    else
      attributes[:name].blank?
    end
  end
  
end
