class Admin::PostCommentsController < Admin::BaseController

  before_action :set_post
  before_action :set_comment, only: :destroy


  def soft_delete
    set_comment.soft_delete
    redirect_to admin_post_path(@post), notice: "コメントを非表示にしました"
  end

  def restore
    set_comment.restore
    redirect_to admin_post_path(@post), notice: "コメントを復元しました"
  end

  private

  def set_post
    @post = Post.unscoped.find(params[:post_id])
  end

  def set_comment
    @comment = @post.post_comments.find(params[:id])
  end

  def comment_params
    params.require(:post_comment).permit(:comment)
  end

end
