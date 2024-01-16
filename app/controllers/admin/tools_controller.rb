class Admin::ToolsController < Admin::BaseController
  before_action :set_tool, only: %i[show edit update destroy]

  def index
    @q = Tool.ransack(params[:q])
    @tools = @q.result.page(params[:page])
  end

  def new
    @tool = Tool.new
  end

  def create
    @tool = Tool.new(tool_params)

    if @tool.save
      flash.now[:success] = 'create successful'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @tool.update(tool_params)
      flash.now[:success] = 'update successful'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tool.destroy!
    flash.now[:success] = 'delete successful'
  end

  private

  def set_tool
    @tool = Tool.find(params[:id])
  end

  def tool_params
    params.require(:tool).permit(:name)
  end
end
