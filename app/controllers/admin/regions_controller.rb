class Admin::RegionsController < Admin::BaseController
  before_action :set_region, only: %i[show edit update destroy]

  def index
    @q = Region.ransack(params[:q])
    @regions = @q.result.page(params[:page])
  end

  def new
    @region = Region.new
  end

  def create
    @region = Region.new(region_params)

    if @region.save
      flash.now[:success] = 'create successful'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @region.update(region_params)
      flash.now[:success] = 'update successful'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @region.destroy!
    flash.now[:success] = 'delete successful'
  end

  private

  def set_region
    @region = Region.find(params[:id])
  end

  def region_params
    params.require(:region).permit(:name)
  end
end
