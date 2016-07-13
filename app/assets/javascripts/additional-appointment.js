(function ($) {
  'use strict';

  window.PWO = window.PWO || {};

  var additionalAppointment = {
    init: function () {
      this.cache();
      this.bindEvents();
      this.subscribe();
      this.ensureCorrectState();
    },
    cache: function () {
      this.$firstAppointmentInput = $('.js-first-appointment');
      this.$appointmentCountWrapper = $('.js-previous-appointments');
      this.$noPreviousAppointmentsInput = $('.js-previous-appointment-0');
      this.$onePreviousAppointmentInput = $('.js-previous-appointment-1');
    },
    bindEvents: function () {
      this.$firstAppointmentInput.on('change', function () {
        $.publish('firstAppointmentChange', this.value);
      });
    },
    subscribe: function() {
      var that = this;
      $.subscribe('firstAppointmentChange', function (e, value) {
        if (value === 'yes') {
          that.$noPreviousAppointmentsInput.prop('checked', true);
          that.$appointmentCountWrapper.fadeOut();
        } else {
          that.$appointmentCountWrapper.fadeIn().attr('aria-live', 'polite');
          if (that.$noPreviousAppointmentsInput.prop('checked')) {
            that.$onePreviousAppointmentInput.prop('checked', true);
          }
        }
      });
    },
    ensureCorrectState: function() {
      this.$firstAppointmentInput.filter(':checked').trigger('change');
    }
  };

  PWO.additionalAppointment = additionalAppointment;

})(jQuery);
