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

mkdir -p ~/tmp
mkdir -p ~/local/src/freedts

wget -P ~/tmp ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.3.10.tar.gz
cd ~/tmp
tar -xvzf freetds-1.3.10.tar.gz
cd freetds-1.3.10
autoconf
./configure
# autoconf
make


#dpkg -x ~/tmp/google-chrome-stable_current_amd64.deb ~/local/src/chrome/
#export PATH="${PATH}:${HOME}/local/src/chrome/opt/google/chrome/"
#rm ~/tmp/google-chrome-stable_current_amd64.deb
#rmdir ~/tmp


# $ ./configure --help
# $ ./configure
# $ make
# $ make install

