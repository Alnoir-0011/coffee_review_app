class PurchaseDecorator < Draper::Decorator
  delegate_all

  def roast_situation
    if store_roast_option_roasted?
      bean.roast_i18n
    else
      store_roast_option_i18n
    end
  end

  def grind_situation
    if store_grind_option_roasted?
      bean.fineness_i18n
    else
      store_grind_option_i18n
    end
  end
end
