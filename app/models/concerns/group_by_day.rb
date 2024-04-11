module GroupByDay
  extend ActiveSupport::Concern

  included do
    scope :group_by_day, -> { group('date(created_at)').order('date_created_at ASC').count }
  end
end
