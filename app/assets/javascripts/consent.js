(function ($) {
  'use strict';

  window.PWO = window.PWO || {};

  var consent = {
    init: function () {
      this.insertHTML();
      this.cache();
      this.bindEvents();
      this.ensureCorrectState();
    },
    insertHTML: function () {
      var html = $('#consent').text();
      $('.consent').append(html);
    },
    cache: function () {
      this.$wrapper = $('.display_if_consent');
      this.$input = $('input[name="appointment_summary[consent]"]');
      this.$errors = $('.alert-danger');
    },
    bindEvents: function () {
      var that = this;
      this.$input.on('change', function () {
        if (this.checked) {
          that.$wrapper.fadeIn();
        } else {
          that.$wrapper.fadeOut();
        }
      });
    },
    ensureCorrectState: function () {
      if (this.$errors.length) {
        this.$input.trigger('click');
      }
    }
  };

  PWO.consent = consent;

})(jQuery);
