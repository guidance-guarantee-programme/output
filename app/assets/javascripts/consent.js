(function ($) {
  'use strict';

  window.PWO = window.PWO || {};

  var consent = {
    init: function () {
      this.insertHTML();
      this.cache();
      this.bindEvents();
    },
    insertHTML: function () {
      var html = $('#consent').html();
      $('.consent').append(html);
    },
    cache: function () {
      this.$wrapper = $('.display_if_consent');
      this.$input = $('input[name="appointment_summary[consent]"]');
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
    }
  };

  PWO.consent = consent;

})(jQuery);
