class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :update]

  def show
  end

  def update
    if params[:user][:deleted_at] == "true"
      @user.update(deleted_at: Time.current)
    else
      @user.update(deleted_at: nil)
    end

    redirect_to admin_user_path(@user), notice: "ユーザー状態を更新しました"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
