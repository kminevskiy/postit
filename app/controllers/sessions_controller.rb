class SessionsController < ApplicationController
  before_action :lock_pin_to_authenticated, only: [:pin]

  def new; end

  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      if user.two_factor_auth?
        session[:two_factor] = true
        user.generate_pin!
        user.send_pin_through_twilio
        redirect_to pin_path
      else
        login_success!(user)
      end
    else
      flash[:error] = "Error with username or password."
      redirect_to register_path
    end
  end

  def pin
    if request.post?
      user = User.find_by(pin: params[:pin])
      if user
        session[:two_factor] = nil
        user.remove_pin!
        login_success!(user)
      else
        flash[:error] = "Incorrect pin. Please try again."
        redirect_to pin_path
      end
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You've been logged out."
    redirect_to root_path
  end

  private

  def login_success!(user)
    flash[:notice] = "You've logged in."
    session[:user_id] = user.id
    redirect_to root_path
  end

  def lock_pin_to_authenticated
    access_denied unless session[:two_factor]
  end
end
