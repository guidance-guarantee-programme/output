(function ($) {
  'use strict';

  window.ROG = window.ROG || {};

  var consent = {
    init: function () {
      this.insertHTML();
      this.cache();
      this.bindEvents();
    },
    insertHTML: function () {
      var html = document.getElementById('consent').innerHTML;
      var $wrapper = $('.consent');
      $wrapper.append(html);
    },
    cache: function () {
      this.$wrapper = $('.display_if_consent');
      this.$input = $('input[name="appointment_summary[consent]"]');
    },
    bindEvents: function () {
      var that = this;
      this.$input.on( 'change', function () {
        if (this.checked) {
          that.$wrapper.fadeIn();
        } else {
          that.$wrapper.fadeOut();
        }
      });
    }
  };

  ROG.consent = consent;

})(jQuery);
