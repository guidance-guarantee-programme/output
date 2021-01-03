class AppointmentSummary < ApplicationRecord # rubocop:disable ClassLength
  enum notify_status: %i(pending delivered failed ignoring)

  DIGITAL_BY_DEFAULT_START_DATE = Date.new(2016, 6, 21)
  # bassed off: https://github.com/alphagov/notifications-utils/blob/master/notifications_utils/recipients.py#L22
  EMAIL_REGEXP = Regexp.union(
    /\A([^";@\s\.]+\.)*[^";@\s\.]+@([^";@\s\.]+\.)+[a-z]{2,10}\z/,
    /\A\z/
  )

  scope :excluding_digital_by_default, lambda {
    where(
      %(
        appointment_summaries.requested_digital IS FALSE
        OR appointment_summaries.date_of_appointment < ?
      ),
      DIGITAL_BY_DEFAULT_START_DATE
    )
  }

  scope :needing_notify_delivery_check, lambda {
    where(
      requested_digital: true,
      notify_completed_at: nil,
      created_at: 2.days.ago.beginning_of_day..Time.zone.now
    ).where.not(notification_id: '')
  }

  def postcode=(str)
    if str.blank?
      super
    else
      super UKPostcode.parse(str).to_s
    end
  end

  TITLES = %w(Mr Mrs Miss Ms Mx Dr Reverend).freeze

  belongs_to :user

  validates :title, presence: true, inclusion: { in: TITLES, allow_blank: true }
  validates :last_name, presence: true
  validates :date_of_appointment, timeliness: { on_or_before: -> { Time.zone.today },
                                                on_or_after: Date.new(2015),
                                                type: :date }
  validates :reference_number, presence: true

  with_options numericality: true, allow_blank: true, if: :eligible_for_guidance? do |eligible|
    eligible.validates :value_of_pension_pots
    eligible.validates :upper_value_of_pension_pots
  end

  validates :guider_name, presence: true

  validates :address_line_1, presence: true, length: { maximum: 50 }
  validates :address_line_2, length: { maximum: 50 }
  validates :address_line_3, length: { maximum: 50 }
  validates :town, presence: true, length: { maximum: 50 }
  validates :county, length: { maximum: 50 }
  validates :postcode, presence: true, postcode: true, if: :uk_address?
  validates :country, presence: true, inclusion: { in: Countries.all }

  validates :has_defined_contribution_pension,
            presence: true,
            inclusion: {
              in: %w(yes no unknown),
              allow_blank: true,
              message: '%{value} is not a valid value'
            }

  validates :has_defined_benefit_pension,
            inclusion: {
              in: %w(yes no),
              message: '%{value} is not a valid value'
            },
            if: -> { has_defined_contribution_pension == 'no' }

  validates :considering_transferring_to_dc_pot,
            inclusion: {
              in: %w(yes no),
              message: '%{value} is not a valid value'
            },
            if: -> { has_defined_benefit_pension == 'yes' }

  validates :format_preference, inclusion: { in: %w(standard large_text braille) }
  validates :appointment_type, inclusion: { in: %w(standard 50_54) }
  validates :covering_letter_type,
            inclusion: { in: %w(section_32 adjustable_income inherited_pot fixed_term_annuity) },
            allow_blank: true
  validates :number_of_previous_appointments, inclusion: { in: 0..3 }
  validates :email, format: EMAIL_REGEXP
  validates :email, presence: true, if: :requested_digital?
  validates :telephone_appointment, inclusion: { in: [true, false] }

  def self.for_redaction
    where
      .not(first_name: Redactor::REDACTED)
      .where('created_at < ?', 2.years.ago.beginning_of_day)
  end

  def self.editable_column_names
    column_names - %w(id created_at updated_at user_id notification_id)
  end

  def format_preference
    super || 'standard'
  end

  def appointment_type
    super || 'standard'
  end

  def eligible_for_guidance?
    %w(yes unknown).include?(has_defined_contribution_pension) ||
      has_defined_benefit_pension == 'yes'
  end

  def can_be_emailed?
    requested_digital? && email.present?
  end

  def stop_checking!
    update_attributes(
      notify_completed_at: Time.zone.now,
      notify_status: :ignoring
    )
  end

  def full_name
    "#{title} #{first_name} #{last_name}"
  end

  def postal_address
    [
      address_line_1,
      address_line_2,
      address_line_3,
      town,
      county,
      postcode
    ].reject(&:empty?).join("\n")
  end

  def organisation_id
    user&.organisation_content_id
  end

  def supplementary_info_selected?
    supplementary_benefits ||
      supplementary_debt ||
      supplementary_ill_health ||
      supplementary_defined_benefit_pensions ||
      supplementary_pension_transfers
  end

  def braille_notification?
    eligible_for_guidance? && braille? && !requested_digital?
  end

  def braille?
    format_preference == 'braille'
  end

  private

  def uk_address?
    Countries.uk?(country)
  end
end
