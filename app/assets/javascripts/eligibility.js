(function ($) {
  'use strict';

  window.PWO = window.PWO || {};

  var eligibility = {
    init: function () {
      this.cache();
      this.bindEvents();
    },
    cache: function () {
      this.$wrapper = $('.display_if_eligible');
      this.$input = $('input[name="appointment_summary[eligibility]"]');
    },
    bindEvents: function () {
      var that = this;
      this.$input.on('change', function () {
        if (this.value !== 'no') {
          that.$wrapper.fadeIn();
        } else {
          that.$wrapper.fadeOut();
        }
      });
    }
  };

  PWO.eligibility = eligibility;

})(jQuery);
