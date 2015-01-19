class Redbooth

  def initialize
    @redis = Redis.new
  end

  def client
    @session = RedboothRuby::Session.new(
      token: @redis.get('token:1:string')
    )
    RedboothRuby::Client.new(@session) if @session.valid?
  end

  def create_task(name)
    client.task(:create, project_id: '1350573', task_list_id: '2747238', name: name)
  end

  def set_credentials(credentials)
    credentials.symbolize_keys!
    @redis.set('token:1:string', credentials[:token])
    @redis.set('refresh_token:1:string', credentials[:refresh_token])
    @redis.set('expires_at:1:string', credentials[:expires_at]) if credentials[:expires]
  end

  def refresh_token
    oauth_client = OAuth2::Client.new(
        RedboothRuby.configuration[:consumer_key],
        RedboothRuby.configuration[:consumer_secret],
        OmniAuth::Strategies::Redbooth.default_options[:client_options].to_h.symbolize_keys
      )
    # @access_token = OAuth2::AccessToken.new(@oauth2_client, @redis.get('token:1:string'))
    new_access_token = OAuth2::AccessToken.new(oauth_client, @redis.get('token:1:string'), {'refresh_token' => @redis.get('refresh_token:1:string')})
    access_token = new_access_token.refresh!
    set_credentials({token: access_token.token, refresh_token: access_token.refresh_token, expires_at: access_token.expires_at, expires_at: true})
  end
end
