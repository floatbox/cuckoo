class InboxWorker
  include Sidekiq::Worker

  PM_PROVIDER = 'redbooth'

  def perform(name, text)
    Task.create(
          author: name,
          title: text,
          status: 'new'
          )
    task_manager = PmTools::Strategy.new(PM_PROVIDER)
    task_manager.create_task(name, text)
  end
end
