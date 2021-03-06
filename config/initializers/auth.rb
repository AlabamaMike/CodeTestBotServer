Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
      :name => 'google',
      :access_type => 'online',
      :image_aspect_ratio => 'square',
      :image_size => 40,
      :hd => ENV['GOOGLE_CLIENT_HOST_DOMAIN']
  }
end
