(function ($) {
  'use strict';

  window.ROG = window.ROG || {};

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
      this.$input.on( 'change', function () {
        if (this.value !== 'no') {
          that.$wrapper.fadeIn();
        } else {
          that.$wrapper.fadeOut();
        }
      });
    }
  };

  ROG.eligibility = eligibility;

})(jQuery);
