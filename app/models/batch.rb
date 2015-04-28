class Batch < ActiveRecord::Base
  has_many :appointment_summaries_batches, dependent: :destroy
  has_many :appointment_summaries, through: :appointment_summaries_batches

  def mark_as_uploaded
    update(uploaded_at: Time.zone.now)
  end
end
