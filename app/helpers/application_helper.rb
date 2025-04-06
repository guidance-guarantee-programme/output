# frozen_string_literal: true
module ApplicationHelper
  def bootstrap_alert_class_for(flash_type)
    case flash_type.to_sym
    when :success
      'alert-success' # Green
    when :error
      'alert-danger' # Red
    when :alert
      'alert-warning' # Yellow
    when :notice
      'alert-info' # Blue
    else
      flash_type.to_s
    end
  end

  def error_messages_for(model)
    render partial: 'shared/errors', locals: { model: model }
  end

  # rubocop:disable Metrics/ParameterLists, Naming/MethodParameterName
  def next_steps_radio_options(form, field, yes: false, no: false, doesnt_know: false, unsure: false,
                               not_applicable: false)
    options = []
    options << next_step_radio_option(form, field, :yes) if yes
    options << next_step_radio_option(form, field, :no) if no
    options << next_step_radio_option(form, field, :doesnt_know, 'Doesn’t know') if doesnt_know
    options << next_step_radio_option(form, field, :unsure) if unsure
    options << next_step_radio_option(form, field, :not_applicable) if not_applicable

    safe_join(options)
  end
  # rubocop:enable Metrics/ParameterLists, Naming/MethodParameterName

  def next_step_radio_option(form, field, value, custom_value = nil)
    render partial: 'shared/next_step_radio_option',
           locals: { form: form, field: field, value: value, custom_value: custom_value }
  end
end
