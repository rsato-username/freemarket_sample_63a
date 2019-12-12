class Item < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many_attached :images
  belongs_to :brand, optional: true
  accepts_nested_attributes_for :brand, reject_if: :reject_both_blank

  

  def self.search(search)
    if search
      Item.where(['name LIKE ? OR description LIKE ?', "%#{search}%", "%#{search}%"])
    else
      Item.all
    end
  end

  def self.categorysearch(search)
    if search
      Item.where(['category_id LIKE ?', "%#{search}%"])
      # Item.where(['brand_id LIKE ?', "%#{search}%"])
    else
      Item.all
    end
  end

  # def self.brandsearch(search)
  #   if search
  #     Item.where(['name LIKE ?', "%#{search}%"])
  #   else
  #     Item.all
  #   end
  # end

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
