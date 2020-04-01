namespace :confidentiality do
  desc 'Redact customer details (REFERENCE=id)'
  task redact: :environment do
    reference = ENV.fetch('REFERENCE')

    Redactor.new(reference).call
  end

  desc 'Redact records greater than 2 years old for GDPR'
  task gdpr: :environment do
    Redactor.redact_for_gdpr
  end
end
