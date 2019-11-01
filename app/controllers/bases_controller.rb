class BasesController < ApplicationController
  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy, :new]
  before_action :admin_user,      only: [:destroy, :index, :new]
  before_action :set_base,      only: [:destroy, :edit, :update]
  
  def index
    @bases = Base.all
  end
  
  def new
    @base = Base.new
  end
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = "拠点情報を追加しました。"
    else
      flash[:danger] = @base.errors.full_messages.join("<br>")
    end
    redirect_to bases_url
  end
  
  def edit
  end
  
  def update
    if @base.update_attributes(base_params)
      flash[:success] = "拠点情報を更新しました。"
    else
      flash[:danger] = @base.errors.full_messages.join("<br>")
    end
    redirect_to bases_url
  end
  
  def destroy
    @base.destroy
    flash[:success] = "拠点情報を削除しました。"
    redirect_to bases_url
  end
  
  private

    def base_params
      params.require(:base).permit(:base_number, :base_name, :base_category)
    end
    
    # beforeフィルター
    
    # paramsハッシュからbaseを取得する
    def set_base
      @base = Base.find(params[:id])
    end
end
