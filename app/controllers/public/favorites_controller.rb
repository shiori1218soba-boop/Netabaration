class Public::FavoritesController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: post_.id)
    favorite.save
    redirect_to group_post_path(group, post)
  end

  def destroy
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: post.id)
    favorite.destroy
    redirect_to group_post_path(group, post)
  end
end
