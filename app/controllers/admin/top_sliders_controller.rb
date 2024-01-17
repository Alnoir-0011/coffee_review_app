class Admin::TopSlidersController < Admin::BaseController
  before_action :set_top_slider, only: %i[edit update destroy]
  def index
    @q = TopSlider.ransack(params[:q])
    @top_sliders = @q.result.page(params[:page])
  end

  def new
    @top_slider = TopSlider.new
  end

  def create
    @top_slider = TopSlider.new(top_slider_params)

    if @top_slider.save
      redirect_to admin_top_sliders_path, success: 'create successful'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @top_slider.update(top_slider_params)
      redirect_to admin_top_sliders_path, success: 'update successful'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @top_slider.destroy!
    flash.now[:success] = 'delete successful'
  end

  def set_top_slider
    @top_slider = TopSlider.find(params[:id])
  end

  def top_slider_params
    params.require(:top_slider).permit(:name, :image, :image_cache, :end_of_publication)
  end
end
