#!/usr/bin/env bash
# exit on error
set -o errexit

# Install FreeDTS and build if it's not in the cache
if [[ ! -d /opt/render/project/nodes/freetds ]]; then
  echo "...Downloading and compiling FreeTDS"
  mkdir -p ~/tmp
  mkdir -p ~/local/bin/freetds

  wget -P ~/tmp ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.3.10.tar.gz
  cd ~/tmp
  tar -xzf freetds-1.3.10.tar.gz
  cd freetds-1.3.10
  autoconf
  ./configure --prefix=/opt/render/project/nodes/freetds
  make
  make install
  cd $HOME/project/src # Make sure we return to where we were
else
  echo "...Using FreeTDS from build cache"
fi

# Set a bundler config option with the path to the freedts directory
bundle config build.tiny_tds --with-freetds-dir=/opt/render/project/nodes/freetds/

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