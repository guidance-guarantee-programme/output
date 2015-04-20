namespace :output_documents do
  desc 'Batch, process and upload output documents'
  task process: :environment do
    ProcessOutputDocuments.new.call
  end
end
