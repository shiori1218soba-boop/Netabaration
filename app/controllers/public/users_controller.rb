class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

  # マイページ
  def mypage
    @user = current_user
    # @posts = current_user.posts.order(created_at: :desc)
    @posts = current_user.posts.where(deleted_at: nil).order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
    # 論理削除されていない投稿だけを取得
    @posts = @user.posts.where(deleted_at: nil).order(created_at: :desc)
  end

  def index
    @users = User.all
  end

  # ユーザー編集
  def edit
  end

  # 更新処理
  def update
    if @user.update(user_params)
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
    params.require(:user).permit(:name, :email, :introduction, :profile_image)
  end

  def set_current_user
    @user = current_user
  end

  def correct_user
    redirect_to mypage_path, alert: "不正なアクセスです" unless @user == current_user
  end

end
