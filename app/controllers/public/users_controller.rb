class Public::UsersController < ApplicationController
  before_action :authenticate_user!

  # マイページ
  def mypage
    @user = current_user
    @posts = current_user.posts.order(created_at: :desc)
  end

  # ユーザー編集
  def edit
    @user = current_user
  end

  # 更新処理
  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報を更新しました。"
      redirect_to mypage_path
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

end
