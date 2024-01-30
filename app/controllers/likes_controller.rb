class LikesController < ApplicationController
  before_action :set_review, only: %i[create destroy]

  def create
    current_user.like(@review)
    flash[:success] = t('.success', item: @review.title)
  end

  def destroy
    current_user.unlike(@review)
    flash[:success] = t('.success', item: @review.title)
  end

  private

  def set_review
    @review = Review.find(params[:review_id])
  end
end
