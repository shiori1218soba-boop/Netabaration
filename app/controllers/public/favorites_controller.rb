class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: post.id)
    favorite.save
    redirect_to group_post_path(post.group, post)
  end

  def destroy
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: post.id)
    favorite.destroy
    redirect_to group_post_path(post.group, post)
  end

  def index
    @posts = current_user.favorite_posts
                         .includes(:user, :group)
                         .order(created_at: :desc)
  end
end
