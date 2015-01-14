require 'tweetstream'

namespace :ts do

  desc "Run Twitter tracking"
  task track: :environment do

    twitter_app = YAML::load_file('config/twitter_app.yml')
    TweetStream.configure do |config|
      config.consumer_key       = twitter_app['consumer_key']
      config.consumer_secret    = twitter_app['consumer_secret']
      config.oauth_token        = twitter_app['oauth_token']
      config.oauth_token_secret = twitter_app['oauth_token_secret']
      config.auth_method        = :oauth
    end

    TweetStream::Client.new.track(twitter_app['track_key']) do |status|
      InboxWorker.perform_async(status.user.screen_name, status.text)
      puts "[#{status.user.screen_name}] #{status.text}"
    end

  end

end
