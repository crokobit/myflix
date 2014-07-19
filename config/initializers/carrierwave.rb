CarrierWave.configure do |config|
  if Rails.env.developement? || Rails.env.test?
    config.storage = :file
  else
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',                        # required
      :aws_access_key_id      => ENV["aws_access_key_id"],                        # required
      :aws_secret_access_key  => ENV["aws_secret_access_key"],                        # required
     :path_style            => true
    }
    config.fog_directory  = 'test.bucket.rails'                     # required
    config.fog_public     = false                                   # optional, defaults to true
  end
end

