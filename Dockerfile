FROM ruby:2.6.0

MAINTAINER JiaRou <laura34963@kdanmobile.com>

# Install dependencies:
# - build-essential: To ensure certain gems can be compiled
# - cron: Run background scheduled task
# - libpq-dev: Communicate with postgres through the postgres gem

RUN apt-get update && apt-get install -qq -y build-essential cron libpq-dev --fix-missing --no-install-recommends

# Set an environment variable to store where the app is installed to inside
# of the Docker image.
ARG RAILS_ENV=development
ENV RAILS_ENV $RAILS_ENV
ENV DATABASE_HOST postgres
ENV REDIS_HOST redis
ENV FLUENT_HOST fluentd

# for datadog log collection
LABEL "com.datadoghq.ad.check_names"='["fluentd"]'
LABEL "com.datadoghq.ad.init_configs"='[{}]'
LABEL "com.datadoghq.ad.instances"='[{"monitor_agent_url": "http://fluentd:24220/api/plugins.json"}]'

# This sets the context of where commands will be ran in and is documented
# on Docker's website extensively.
WORKDIR /store_center

# Ensure gems are cached and only get updated when they change. This will
# drastically increase build times when your gems do not change.
RUN gem install bundler:2.1.4
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy in the application code from your work station at the current directory
# over to the working directory.
COPY . .
RUN mkdir -p tmp/pids tmp/cache tmp/sockets

# setup container label
ARG BRANCH=none
ARG COMMIT=none
LABEL branch=$BRANCH commit=$COMMIT env=$RAILS_ENV

# expose port
EXPOSE 3000

ENTRYPOINT ["bundle", "exec"]
CMD ["puma", "-C", "config/puma.rb"]
