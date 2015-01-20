module PmTools
  module User

    def user_id
      @user_id ||= @redis.get('current_user_id:1:int')
    end

    def user_id= value
      @redis.set('current_user_id:1:int', value)
    end

    def user_name
      @redis.get("user_name:#{user_id}:string")
    end

    def user_name= value
      @redis.set("user_name:#{user_id}:string", value)
    end

    def user_email
      @redis.get("user_email:#{user_id}:string")
    end

    def user_email= value
      @redis.set("user_email:#{user_id}:string", value)
    end

    def set_user(user)
      user.symbolize_keys!
      self.user_id = user[:uid]
      self.user_name = user[:name] if user[:name]
      self.user_email = user[:email] if user[:email]
    end

  end
end
