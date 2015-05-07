process_output_documents: bundle exec rake output_documents:process && ([ -n "$PROCESS_OUTPUT_DOCUMENTS_SNITCH_URL" ] && curl $PROCESS_OUTPUT_DOCUMENTS_SNITCH_URL &>/dev/null)
web: bin/puma -C config/puma.rb
worker: bin/sidekiq -C config/sidekiq.yml
