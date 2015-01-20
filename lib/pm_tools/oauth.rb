module PmTools
  module Oauth

    def client
      refresh_token! if token_expired?
      provider_client
    end

    def token
      @redis.get('token:1:string')
    end

    def token= value
      @redis.set('token:1:string', value)
    end

    def refresh_token
      @redis.get('refresh_token:1:string')
    end

    def refresh_token= value
      @redis.set('refresh_token:1:string', value)
    end

    def expires_at
      @redis.get('expires_at:1:int').to_i
    end

    def expires_at= value
      @redis.set('expires_at:1:int', value)
    end

    def set_credentials(credentials)
      credentials.symbolize_keys!
      self.token = credentials[:token]
      self.refresh_token = credentials[:refresh_token]
      self.expires_at = credentials[:expires_at] if credentials[:expires]
    end

    def token_expired?
      return true if expires_at < Time.now.to_i
    end

    private

    def refresh_token!
      oauth_client = OAuth2::Client.new(
        consumer_key,
        consumer_secret,
        client_options
      )
      new_access_token = OAuth2::AccessToken.new(oauth_client, token, {refresh_token: refresh_token})
      access_token = new_access_token.refresh!
      set_credentials({
        token: access_token.token,
        refresh_token: access_token.refresh_token,
        expires_at: access_token.expires_at,
        expires: true
      })
    end

  end
end
