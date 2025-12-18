class Admin::HomesController < Admin::BaseController

 def top
    @users = User.order(created_at: :desc)
  end

end
