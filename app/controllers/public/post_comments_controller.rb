class Public::PostCommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: :destroy
  before_action :authorize_user!, only: :destroy

  def create
    @comment = @post.post_comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to post_path(@post), notice: "コメントを投稿しました"
    else
      flash[:alert] = @comment.errors.full_messages
      redirect_to post_path(@post)
    end
  end

  def destroy
    @comment.soft_delete
    redirect_to post_path(@post), notice: "コメントを削除しました"
  end

  private

  def set_post
    @post = Post.active.find(params[:post_id])
  end

  def set_comment
    @comment = @post.post_comments.find(params[:id])
  end

  def authorize_user!
    unless @comment.user_id == current_user.id
      redirect_to post_path(@post), alert: "削除する権限がありません"
    end
  end

  def comment_params
    params.require(:post_comment).permit(:comment)
  end

end
