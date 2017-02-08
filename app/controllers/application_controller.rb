class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :require_admin

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    access_denied unless logged_in?
  end

  def require_logged_out
    if logged_in?
      flash[:error] = "Must be logged out to do that."
      redirect_to root_path
    end
  end

  def require_admin
    access_denied unless logged_in? && current_user.admin?
  end

  def access_denied
    flash[:error] = "You can't do that."
    redirect_to root_path
  end
end
