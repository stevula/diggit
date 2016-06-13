class Api::SessionsController < Api::BaseController
  prepend_before_filter :require_no_authentication, :only => [:create]
  before_filter :ensure_params_exist
  
  def create
    # build_resource
    resource = User.find_for_database_authentication(username: user_params[:username])
    return invalid_login_attempt unless resource

    debugger
    if resource.valid_password?(user_params[:password])
      sign_in("user", resource)
      return
    end
    invalid_login_attempt
  end

  def after_create
    render json: {
      success: true,
      auth_token: resource.authentication_token,
      login: resource.login,
      email: resource.email
    }
  end
  
  def destroy
    sign_out(resource_name)
  end

  protected

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def ensure_params_exist
    return unless user_params[:username].blank?
    render json: {success: false, message: "missing user_login parameter"}, status: 422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render json:  {success: false, message: "Error with your login or password"}, status: 401
  end
end