class Admin::PostsController < Admin::BaseController
  before_action :set_post, only: [:show, :update]

  def index
    @posts = Post.includes(:user)
                 .order(created_at: :desc)

    if params[:keyword].present?
      @posts = @posts.where("title LIKE ? OR body LIKE ?",
                             "%#{params[:keyword]}%",
                             "%#{params[:keyword]}%")
    end
  end

  def show
    @post_comment = PostComment.all
  end

  def update
    @post.deleted? ? @post.restore : @post.soft_delete

    redirect_to admin_post_path(@post)
  end

  private

  def set_post
    @post = Post.unscoped.find(params[:id])
  end

end
