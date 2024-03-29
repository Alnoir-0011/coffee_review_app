class TopSlider < ApplicationRecord
  mount_uploader :image, SliderUploader

  validates :image, presence: true
  validates :name, presence: true, length: { maximum: 255 }

  validate :past_date_cannot, unless: -> { end_of_publication.nil? }

  def self.ransackable_attributes(auth_object = nil)
    authorizable_ransackable_attributes
  end

  def self.ransackable_associations(auth_object = nil)
    authorizable_ransackable_associations
  end

  private

  def past_date_cannot
    errors.add(:end_of_publication, 'は過去の日付を登録できません') if end_of_publication > DateTime.current
  end
end
