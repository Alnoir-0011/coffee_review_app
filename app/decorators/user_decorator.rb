class UserDecorator < Draper::Decorator
  delegate_all

  def tool_names
    if self.tools.present?
      self.tools.pluck(:name).join(" ")
    else
      '未登録'
    end
  end
end
