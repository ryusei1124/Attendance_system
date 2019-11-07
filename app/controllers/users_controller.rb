class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :update_basic_info]
  before_action :set_one_month, only: :show
  before_action :admin_hidden, only: :show
  before_action :admin_or_correct_user, only: :show
  
  def new
    @user = User.new
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    respond_to do |format|
      format.html
      format.csv do 
        send_data render_to_string, filename: "#{@user.name}.csv", type: :csv
      end
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "新規登録に成功しました。"
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end
  
  def index
    if params[:q] && params[:q].reject { |key, value| value.blank? }.present?
      @q = User.ransack(search_params, activated_true: true)
      @title = "検索結果"
    else
      @q = User.ransack(activated_true: true)
      @title = "ユーザー一覧"
    end
    @users = @q.result.paginate(page: params[:page])
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}さんの基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name_was}さんの更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  def import
    if params[:file].blank?
      flash[:danger] = "インポートするCSVファイルを選択してください。"
    else
      User.import(params[:file])
      flash[:success] = "ユーザーを追加しました。"
    end
    redirect_to users_url
  end
  
  def on_duty
    @working_users = []
    @working_employee_number = []
    User.all.each do |user|
      if user.attendances.any?{|day| ( day.worked_on == Date.today && !day.started_at.blank? && day.finished_at.blank? )}
        @working_users.push(user.name)
        @working_employee_number.push(user.employee_number)
      end
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:name, :email, :affiliation, :uid, :employee_number, :password, :password_confirmation, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end
    
    # 検索機能
    def search_params
      params.require(:q).permit(:name_cont)
    end
    
    # beforeアクション
    
    # 管理者は勤怠画面の表示禁止
    def admin_hidden
      redirect_to(root_url) if current_user.admin?
    end
    
end
