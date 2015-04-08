class Batch < ActiveRecord::Base
  has_many :appointment_summaries_batches
  has_many :appointment_summaries, through: :appointment_summaries_batches
end
