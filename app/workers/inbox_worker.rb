class InboxWorker
  include Sidekiq::Worker

  def perform(name, text)
    Task.create(
          author: name,
          title: text,
          status: 'new'
          )
    task_manager = Redbooth.new
    task_manager.create_task(name, text)
  end
end
