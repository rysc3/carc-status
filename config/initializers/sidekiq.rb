require 'sidekiq'

# Set the Redis URL to use the host IP address and forwarded port
redis_host = ENV['REDIS_HOST'] || '127.0.0.1'
redis_port = ENV['REDIS_PORT'] || '6379'

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{redis_host}:#{redis_port}" }
end

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{redis_host}:#{redis_port}" }
end

# Schedule the worker to run every 5 seconds
UpdateNodesWorker.perform_in(5.seconds)
