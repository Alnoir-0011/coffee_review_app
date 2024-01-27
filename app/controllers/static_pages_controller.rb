class StaticPagesController < ApplicationController
  skip_before_action :require_login

  def terms_of_use; end

  def privacy_policy; end
end
