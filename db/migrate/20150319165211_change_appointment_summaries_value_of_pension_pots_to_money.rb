class ChangeAppointmentSummariesValueOfPensionPotsToMoney < ActiveRecord::Migration[4.2]
  def change
    change_column :appointment_summaries, :value_of_pension_pots,
                  'money USING CAST(value_of_pension_pots AS money)'
  end
end
