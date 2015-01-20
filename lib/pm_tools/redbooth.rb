module PmTools
  class Redbooth

    include PmTools::Oauth

    def initialize(attributes={})
      @redis = Redis.new
      set_credentials(attributes[:credentials]) if attributes.try(:[], :credentials)
    end

    def provider_client
      @session = RedboothRuby::Session.new(
        token: token
      )
      RedboothRuby::Client.new(@session) if @session.valid?
    end

    def client_options
      OmniAuth::Strategies::Redbooth.default_options[:client_options].to_h.symbolize_keys
    end

    def consumer_key
      RedboothRuby.configuration[:consumer_key]
    end

    def consumer_secret
      RedboothRuby.configuration[:consumer_secret]
    end

    def create_task(name, text, context)
      client.task(:create,
        project_id: '1350573',
        task_list_id: '2747238',
        name: name,
        description: text
      )
    end

  end
end
