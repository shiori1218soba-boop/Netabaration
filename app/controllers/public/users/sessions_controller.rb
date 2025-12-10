class Public::Users::SessionsController < Devise::SessionsController
  def after_sign_in_path_for(resource)
    public_posts_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

end
