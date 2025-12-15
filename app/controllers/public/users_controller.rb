class Public::UsersController < ApplicationController
  before_action :authenticate_user!

  # マイページ
  def mypage
    @user = current_user
    # @posts = current_user.posts.order(created_at: :desc)
    @posts = current_user.posts.where(deleted_at: nil).order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def index
    @user = User.all
  end

  # ユーザー編集
  def edit
    @user = current_user

    unless @user == current_user
      redirect_to mypage_path, alert: "不正なアクセスです"
    end
  end

  # 更新処理
  def update
    @user = current_user
    was_inactive = @user.is_active == false

    unless @user == current_user
      redirect_to mypage_path, alert: "不正なアクセスです"
      return
    end

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
    user = current_user   # current_userをローカル変数に退避

    # 論理削除
    user.withdraw!

    # サインアウトしてセッションリセット
    sign_out user
    reset_session

    # ログイン画面へ
    redirect_to new_user_registration_path, notice: "退会処理が完了しました。"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :introduction, :is_active)
  end

end
