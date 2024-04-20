class UserDecorator < Draper::Decorator
  delegate_all

  def tool_names
    if tools.present?
      tools.pluck(:name).join(' ')
    else
      I18n.t('defaults.unregistered')
    end
  end

  def brewing_method_names
    if brewing_methods.present?
      brewing_methods.pluck(:name).join(' ')
    else
      I18n.t('defaults.unregistered')
    end
  end
end
