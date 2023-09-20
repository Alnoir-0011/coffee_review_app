class User < ApplicationRecord
  authenticates_with_sorcery!

  mount_uploader :avatar, AvatorUploader

  has_many :purchases, dependent: :destroy
  has_many :user_tools, dependent: :destroy
  has_many :tools, through: :user_tools
  has_many :reviews, through: :purchases
  has_many :brewing_prefences, dependent: :destroy
  has_many :brewing_methods, through: :brewing_prefences

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :name, presence: true, length: { maximum: 255 }

  def save_with_associations(tool_ids:, brewing_method_ids:)
    ActiveRecord::Base.transaction do
      # binding.pry
      self.tools = tool_ids.reject(&:empty?).map { |id| Tool.find(id) }
      self.brewing_methods = brewing_method_ids.reject(&:empty?).map { |id| BrewingMethod.find(id) }
      save!
    end
    true
  rescue StandardError
    false
  end

  def tool_ids
    tools.ids
  end

  def brewing_method_ids
    brewing_methods.ids
  end
end
