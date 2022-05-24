#!/usr/bin/env bash
# exit on error
set -o errexit

# Download FreeTDS and compile if it's not in the cache
if [[ ! -d $XDG_CACHE_HOME/freetds ]]; then
  echo "...Downloading and compiling FreeTDS"
  mkdir -p ~/tmp

  wget -P ~/tmp ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.3.10.tar.gz
  cd ~/tmp
  tar -xzf freetds-1.3.10.tar.gz
  cd freetds-1.3.10
  autoconf
  ./configure --prefix=$XDG_CACHE_HOME/freetds
  make
  make install
  cd $HOME/project/src # Make sure we return to where we were
else
  echo "...Using FreeTDS from build cache"
fi

# Set a bundler config option with the path to the freeTDS directory
bundle config build.tiny_tds --with-freetds-dir=$XDG_CACHE_HOME/freetds/

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