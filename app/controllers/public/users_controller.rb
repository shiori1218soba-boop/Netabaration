class Public::UsersController < ApplicationController
  before_action :authenticate_user!

  # マイページ
  def mypage
    @user = current_user
    # @posts = current_user.posts.order(created_at: :desc)
    @posts = current_user.posts.where(deleted_at: nil).order(created_at: :desc)
  end

  # ユーザー編集
  def edit
    @user = current_user
  end

  # 更新処理
  def update
    @user = current_user
    was_inactive = @user.is_active == false

    if @user.update(user_params)
      # 退会状態 → アクティブに戻った時だけ投稿も復元
      if was_inactive && @user.is_active == true
        @user.restore_posts
      end

      flash[:notice] = "ユーザー情報を更新しました。"
      redirect_to mypage_path
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit
    end
  end

  # 退会確認ページ
  def unsubscribe
    @user = current_user
  end


  # 退会処理（論理削除）
  def withdraw
    @user = current_user

    # ユーザー論理削除
    @user.update(is_active: false)

    # ユーザーの投稿も論理削除
    @user.posts.update_all(deleted_at: Time.current)

    # サインアウト
    sign_out @user
    reset_session

    redirect_to root_path, notice: "退会処理が完了しました。"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

end
