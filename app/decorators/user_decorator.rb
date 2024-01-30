class UserDecorator < Draper::Decorator
  delegate_all

  def tool_names
    if self.tools.present?
      self.tools.pluck(:name).join(" ")
    else
      I18n.t('defaults.unregistered')
    end
  end

  def brewing_method_names
    if self.brewing_methods.present?
      self.brewing_methods.pluck(:name).join(" ")
    else
      I18n.t('defaults.unregistered')
    end
  end
end
