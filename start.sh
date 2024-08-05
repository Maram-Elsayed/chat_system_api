rm -f /chat_system_api/tmp/pids/server.pid

bundle install

bundle exec rails db:create
bundle exec rails db:migrate
rails setup_elasticsearch.rb

bundle exec rails server -b '0.0.0.0'
