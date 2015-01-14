Rails.application.config.middleware.use OmniAuth::Builder do
  redbooth_app = YAML::load_file('config/redbooth_app.yml')
  provider :redbooth,
    redbooth_app['client_id'],
    redbooth_app['client_secret']
end
