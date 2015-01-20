module PmTools
  class Redbooth

    TASK_LIST_NAME = 'Twitter mentions'

    include PmTools::Oauth
    include PmTools::User
    include PmTools::RedboothUser

    def initialize(attributes={})
      @redis = Redis.new
      set_credentials(attributes[:credentials]) if attributes.try(:[], :credentials)
      set_user(attributes[:user]) if attributes.try(:[], :user)
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
        project_id: project_id,
        task_list_id: task_list_id,
        name: name,
        description: text
      )
    end

    def get_user_projects
      client.project(:index).all
    end

    def create_task_list(name = TASK_LIST_NAME)
      client.task_list(:create, project_id: project_id, name: name)
    end

    def get_task_list(tsid)
      client.task_list(:show, id: tsid)
    rescue OAuth2::Error
      return false
    end

  end
end
