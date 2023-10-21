class LikesController < ApplicationController
  before_action :set_review, only: %i[create destroy]

  def create
    # binding.pry
    current_user.like(@review)
    flash[:success] = "#{@review.title}をいいねしました"
  end

  def destroy
    current_user.unlike(@review)
    flash[:success] = "#{@review.title}のいいねを削除しました"
  end

  private

  def set_review
    @review = Review.find(params[:review_id])
  end
end
