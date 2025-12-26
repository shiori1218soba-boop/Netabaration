class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_group
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    # 論理削除されていない投稿だけを表示
    @posts = @group.posts
                   .active
                   .includes(:user)
                   .order(created_at: :desc)
  end

  def show
    # @post = Post.find(params[:id])
    # set_post で取得済み
    @comments = @post.post_comments.includes(:user)
    @comment = PostComment.new
  end

  def new
    @post = Post.new
  end

  def edit
    # @post は before_action で取得済み
  end

  def update
    if @post.update(post_params)
      redirect_to group_post_path(@post), notice: "投稿を更新しました。"
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.soft_delete
    redirect_to group_path(@group), notice: "投稿を削除しました。"
  end

  def create
    @post = @group.posts.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      redirect_to group_post_path(@group, @post), notice: "投稿しました！"
    else
      render :new
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_post
    @post = @group.posts.active.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end

  def correct_user
    unless @post.user_id == current_user.id
      flash[:alert] = "権限がありません。"
      redirect_to group_path
    end
  end

end
