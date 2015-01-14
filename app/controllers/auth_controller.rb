class AuthController < ApplicationController

  # GET /callback
  def callback
    render text: MultiJson.encode(request.env['omniauth.auth'])
  end

end
