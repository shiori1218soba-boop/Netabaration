class Admin::GroupsController < ApplicationController
  def index
    @groups = Group.unscoped.all
  end

  def show
    @group = Group.unscoped.find(params[:id])
    @posts = @group.posts.includes(:user)
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.owned_groups.build(group_params)
    if @group.save
      redirect_to group_path(@group), notice: "グループを作成しました"
    else
      render :new
    end
  end

  def destroy
    @group = Group.find(params[:id])
    if @group.owner == current_user
      @group.soft_delete
    end
    redirect_to public_groups_path
  end
  
  def restore
    Group.unscoped.find(params[:id]).restore
    redirect_to admin_groups_path
  end


  private

  def group_params
    params.require(:group).permit(:name, :introduction)
  end
end
