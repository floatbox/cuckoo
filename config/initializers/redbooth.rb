redbooth_app = YAML::load_file('config/redbooth_app.yml')
RedboothRuby.config do |configuration|
    configuration[:consumer_key] = redbooth_app['client_id']
    configuration[:consumer_secret] = redbooth_app['client_secret']
end

