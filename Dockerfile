FROM ruby:3.2.0

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# Install Redis
RUN apt-get update && apt-get install -y redis-server

# Set up working directory
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs

# Install the correct version of Bundler
RUN gem install bundler:2.2.33

# Copy Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --jobs 4 --retry 3

# Copy the rest of the application code
COPY . .

# Expose port 3000 for rails server
EXPOSE 3000
# Expose port 6379 for redis
EXPOSE 6379

# Start Redis server
CMD ["redis-server", "--daemonize", "yes"]

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
