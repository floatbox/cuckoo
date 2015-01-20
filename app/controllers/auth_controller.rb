class AuthController < ApplicationController

  # GET /callback
  def callback
    omniauth_auth = request.env['omniauth.auth']
    current_user = {
      uid: omniauth_auth['uid'],
      name: omniauth_auth['info']['name'],
      email: omniauth_auth['info']['email'],
    }
    session[:current_user] = current_user
    PmTools::Strategy.new(omniauth_auth['provider'], credentials: omniauth_auth['credentials'], user: current_user)
    redirect_to root_url
  end

  # GET /logout
  def logout
    reset_session
    redirect_to root_url
  end

end
