class PurchaseDecorator < Draper::Decorator
  delegate_all

  def roast_situation
    if self.store_roast_option_roasted?
      self.bean.roast
    else
      self.store_roast_option
    end
  end

  def grind_situation
    if self.store_grind_option_roasted?
      self.bean.fineness
    else
      self.store_grind_option
    end
  end
end
