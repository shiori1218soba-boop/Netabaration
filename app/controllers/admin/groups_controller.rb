class Admin::GroupsController < Admin::BaseController

  def index
    @groups = Group.unscoped.all
  end

  def show
    @group = Group.unscoped.find(params[:id])
    @posts = @group.posts.includes(:user)
  end


  def destroy
    group = Group.unscoped.find(params[:id])
    group.soft_delete
    redirect_to admin_group_path, notice: "グループを非表示にしました"
  end

  def restore
    group = Group.unscoped.find(params[:id])
    group.restore
    redirect_to admin_group_path, notice: "グループを再表示しました"
  end


  private

  def group_params
    params.require(:group).permit(:name, :introduction)
  end
end
