class AppointmentSummary < ApplicationRecord # rubocop:disable Metrics/ClassLength
  enum :notify_status, %i(pending delivered failed ignoring)

  DIGITAL_BY_DEFAULT_START_DATE = Date.new(2016, 6, 21)
  # bassed off: https://github.com/alphagov/notifications-utils/blob/master/notifications_utils/recipients.py#L22
  EMAIL_REGEXP = Regexp.union(
    /\A([^";@\s\.]+\.)*[^";@\s\.]+@([^";@\s\.]+\.)+[a-zA-Z]{2,10}\z/,
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

  TITLES = %w(Mr Mrs Miss Ms Mx Dr Reverend Sir Dame).freeze

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

  validates :guider_name, presence: true, if: :pension_wise?

  validates :address_line_1, presence: true, length: { maximum: 50 }, if: :requested_postal?
  validates :address_line_2, length: { maximum: 50 }, if: :requested_postal?
  validates :address_line_3, length: { maximum: 50 }, if: :requested_postal?
  validates :town, presence: true, length: { maximum: 50 }, if: :requested_postal?
  validates :county, length: { maximum: 50 }, if: :requested_postal?
  validates :postcode, presence: true
  validates :postcode, postcode: true, if: :postcode_format_required?
  validates :country, presence: true, inclusion: { in: Countries.all }, if: :requested_postal?

  validates :has_defined_contribution_pension,
            presence: true,
            inclusion: {
              in: %w(yes no unknown),
              allow_blank: true,
              message: '%{value} is not a valid value'
            },
            if: :pension_wise?

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

  with_options presence: true, if: :requires_next_steps? do
    validates :updated_beneficiaries
    validates :regulated_financial_advice
    validates :kept_track_of_all_pensions
    validates :interested_in_pension_transfer
    validates :created_retirement_budget
    validates :know_how_much_state_pension
    validates :received_state_benefits
    validates :pension_to_pay_off_debts
    validates :living_or_planning_overseas
    validates :finalised_a_will
    validates :setup_power_of_attorney
  end

  def self.for_redaction
    where
      .not(first_name: Redactor::REDACTED)
      .where('created_at < ?', 2.years.ago.beginning_of_day)
  end

  def self.editable_column_names
    column_names - %w(id created_at updated_at user_id notification_id)
  end

  def self.for_tap_reissue(tap_reference)
    where(
      reference_number: tap_reference,
      requested_digital: true,
      telephone_appointment: true
    ).order(created_at: :desc).first
  end

  def standard?
    appointment_type == 'standard'
  end

  def requested_postal?
    !requested_digital?
  end

  def has_defined_contribution_pension # rubocop:disable Naming/PredicateName
    return 'unknown' if due_diligence?

    super
  end

  def format_preference
    super || 'standard'
  end

  def appointment_type
    super || 'standard'
  end

  def eligible_for_guidance?
    %w(yes unknown).include?(has_defined_contribution_pension) ||
      (has_defined_benefit_pension == 'yes' && considering_transferring_to_dc_pot == 'yes')
  end

  def can_be_emailed?
    requested_digital? && email.present?
  end

  def stop_checking!
    update(
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

  def pension_wise?
    schedule_type == 'pension_wise'
  end

  def due_diligence?
    schedule_type == 'due_diligence'
  end

  def notify_via_email
    return unless can_be_emailed?

    if due_diligence?
      NotifyDueDiligenceViaEmail.perform_later(self)
    else
      NotifyViaEmail.perform_later(self)
    end
  end

  def requires_next_steps?
    eligible_for_guidance? && pension_wise?
  end

  private

  def postcode_format_required?
    requested_postal? && Countries.uk?(country)
  end
end
