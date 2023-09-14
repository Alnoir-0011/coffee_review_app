class Bean < ApplicationRecord
  
  belongs_to :regions
  
  validates :name, presence: true, length: { maximum: 255 }
  
  enum :roast, { beans: 0, light: 10, chinamon: 20, medium: 30, high: 40, city: 50, fullcity: 60, fremch: 70, italian: 80 }, prefix: true
  
  enum :fineness, { beans: 0, coarsely: 10, medium: 20, medium_fine: 30, fine: 40, superfine: 50 }, prefix: true
  
  def self.ransackable_attributes(auth_object = nil)
    authorizable_ransackable_attributes
  end

  def self.ransackable_associations(auth_object = nil)
    authorizable_ransackable_attributes
  end
end
