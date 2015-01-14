class InboxWorker
  include Sidekiq::Worker

  def perform(name, text)
    Task.create(
          author: name,
          title: text,
          status: 'new'
          )
  end
end
