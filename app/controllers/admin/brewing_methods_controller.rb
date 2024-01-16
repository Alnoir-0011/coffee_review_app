class Admin::BrewingMethodsController < Admin::BaseController
  before_action :set_brewing_method, only: %i[show edit update destroy]

  def index
    @q = BrewingMethod.ransack(params[:q])
    @brewing_methods = @q.result.page(params[:page])
  end

  def new
    @brewing_method = BrewingMethod.new
  end

  def create
    @brewing_method = BrewingMethod.new(brewing_method_params)

    if @brewing_method.save
      flash.now[:success] = 'create successful'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @brewing_method.update(brewing_method_params)
      flash.now[:success] = 'update successful'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @brewing_method.destroy!
    flash.now[:success] = 'delete successful'
  end

  private

  def set_brewing_method
    @brewing_method = BrewingMethod.find(params[:id])
  end

  def brewing_method_params
    params.require(:brewing_method).permit(:name)
  end
end
