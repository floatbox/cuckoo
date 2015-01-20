module PmTools
  module RedboothUser

    def project_id
      pid = @redis.get("project_id:#{user_id}:int")
      unless pid
        pid = get_user_projects.last.id
        @redis.set("project_id:#{user_id}:int", pid)
      end
      pid.to_i
    end

    def task_list_id
      tlid = @redis.get("task_list_id:#{user_id}:int")
      unless tlid && get_task_list(tlid)
        tlid = create_task_list.id
        @redis.set("task_list_id:#{user_id}:int", tlid)
        puts tlid;
      end
      tlid.to_i
    end

  end
end
