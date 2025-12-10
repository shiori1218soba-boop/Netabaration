class Public::Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    # sign_up 時に許可する項目
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end

    # account_update 時に許可する項目
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end
end
