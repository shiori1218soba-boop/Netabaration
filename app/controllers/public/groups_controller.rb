class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update]
  before_action :ensure_owner, only: [:edit, :update]

  def index
    @groups = Group.all.order(created_at: :desc)
  end

  def show
    @posts = @group.posts.active.includes(:user).order(created_at: :desc)
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

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to group_path(@group), notice: "グループ情報を更新しました"
    else
      flash.now[:alert] = @group.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group = Group.find(params[:id])
    if @group.owner == current_user
      @group.soft_delete
    end
    redirect_to groups_path(@group)
  end

  private

  def set_group
    @group = @post.group
  end

  def ensure_owner
    unless @group.owner_id == current_user.id
      redirect_to group_path(@group), alert: "編集権限がありません"
    end
  end

  def group_params
    params.require(:group).permit(:name, :introduction)
  end
end
