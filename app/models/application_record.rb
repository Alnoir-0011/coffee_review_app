class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.ransackable_attributes(auth_object = nil)
    authorizable_ransackable_attributes if auth_object&.admin?
  end

  def self.ransackable_associations(auth_object = nil)
    authorizable_ransackable_associations if auth_object&.admin?
  end
end
