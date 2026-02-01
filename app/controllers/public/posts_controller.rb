class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_group
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    # 論理削除されていない投稿だけを表示
    @posts = @group.posts
                   .active
                   .includes(:user)
                   .order(created_at: :desc)
  end

  def show
    @comments = @post.post_comments.includes(:user)
    @comment = PostComment.new
  end

  def new
    @post = @group.posts.new
  end

  def create
    @post = @group.posts.new(post_params)
    @post.user = current_user

    if @post.save
      redirect_to group_post_path(@group, @post), notice: "投稿しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @post は before_action で取得済み
  end

  def update
    if @post.update(post_params)
      redirect_to group_post_path(@group, @post), notice: "投稿を更新しました。"
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.soft_delete
    redirect_to group_path(@group), notice: "投稿を削除しました。"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def set_group
    @group = @post.group
  end

  def post_params
    params.require(:post).permit(:title, :body,  images: [])
  end

  def correct_user
    unless @post.user_id == current_user.id
      flash[:alert] = "権限がありません。"
      redirect_to group_path(@group)
    end
  end

end
