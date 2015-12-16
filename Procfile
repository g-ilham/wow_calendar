web: bundle exec rails server -p $PORT
worker: bundle exec sidekiq -q default -q mailers -e $RACK_ENV -c 3
