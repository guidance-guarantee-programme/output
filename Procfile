web: bin/puma -C config/puma.rb
worker: bin/sidekiq -C config/sidekiq.yml
release: bundle exec rails db:migrate
