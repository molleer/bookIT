class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_user_api_token
  after_action :allow_iframe

  rescue_from UserNotFoundError do |exception|
    reset_session
    redirect_to signin_path
  end

  private

  def current_user
    raise UserNotFoundError if session[:user_id].nil?
    @user ||= User.find(session[:user_id])
  end

  def allow_iframe
    response.headers['X-Frame-Options'] = 'ALLOW-FROM https://chalmers.it'
  end

  def signed_in?
    current_user.present?
  end

  def set_user_api_token
    RequestStore.store[:account_token] = session[:token]
  end

  helper_method :current_user, :signed_in?
end
