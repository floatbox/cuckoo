class AuthController < ApplicationController

  # GET /callback
  def callback
    omniauth_auth = request.env['omniauth.auth']
    session[:current_user] = {
      id: omniauth_auth['uid'],
      info: omniauth_auth['info'].to_h,
      credentials: omniauth_auth['credentials'].to_h
    }
    PmTools::Strategy.new(omniauth_auth['provider'], credentials: omniauth_auth['credentials'])
    redirect_to root_url
  end

  # GET /logout
  def logout
    reset_session
    redirect_to root_url
  end

end
