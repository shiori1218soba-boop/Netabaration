class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    # 論理削除されていない投稿だけを表示
    @posts = Post.where(deleted_at: nil).includes(:user).order(created_at: :desc)
  end

  def show
    # @post = Post.find(params[:id])
    # set_post で取得済み。削除済みなら 404 にする
    if @post.deleted?
      redirect_to public_posts_path, alert: "投稿が見つかりませんでした"
    end
  end

  def new
    @post = Post.new
  end

  def edit
    # @post は before_action で取得済み
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿を更新しました。"
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to mypage_path, notice: "投稿を削除しました。"
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      redirect_to post_path(@post), notice: "投稿しました！"
    else
      render :new
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end

  def correct_user
    @post = Post.find(params[:id])
    unless @post.user_id == current_user.id
      flash[:alert] = "権限がありません。"
      redirect_to posts_path
    end
  end

end
