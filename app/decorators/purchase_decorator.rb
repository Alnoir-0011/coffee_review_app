class PurchaseDecorator < Draper::Decorator
  delegate_all

  def roast_situation
    if self.store_roast_option_roasted?
      self.bean.roast_i18n
    else
      self.store_roast_option_i18n
    end
  end

  def grind_situation
    if self.store_grind_option_roasted?
      self.bean.fineness_i18n
    else
      self.store_grind_option_i18n
    end
  end
end
