#!/usr/bin/env bash
# exit on error
set -o errexit

# We always want these run
bundle config set --local without 'development test'
bundle install

# Only run these tasks on the web service
if [ "$RENDER_SERVICE_TYPE" = 'web' ]
then
  echo "Service type is WEB..."

  echo "...running rake assets:precompile"
  bundle exec rake assets:precompile

  # bundle exec rake assets:clean
  echo "...running rake db:migrate"
  bundle exec rake db:migrate
else
  echo "Not a web process so nothing to do here."  
fi