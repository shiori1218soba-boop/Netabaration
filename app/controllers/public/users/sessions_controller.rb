class Public::Users::SessionsController < Devise::SessionsController

  before_action :reject_user, only: [:create]

  def after_sign_in_path_for(resource)
    mypage_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end
  
  def reject_user
    @user = User.find_by(email: params[:user][:email])
    return if @user.nil?

    if @user.valid_password?(params[:user][:password]) && !@user.is_active
      flash[:alert] = "このアカウントは退会済みです。"
      redirect_to new_user_session_path
    end
  end

end
