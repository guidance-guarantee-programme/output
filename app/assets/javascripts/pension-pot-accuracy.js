(function ($) {
  'use strict';

  window.ROG = window.ROG || {};

  var pensionPotAccuracy = {
    init: function () {
      this.insertHTML();
      this.cache();
      this.bindEvents();
    },
    insertHTML: function () {
      var options = document.getElementById('pension_pot_accuracy').innerHTML;
      var $column = $('#col-pension-pot-value');
      $column.before(options);
    },
    cache: function () {
      this.$wrapper = $('.display_if_range');
      this.$input = $('input[name="appointment_summary[accuracy]"]');
    },
    bindEvents: function () {
      this.$input.on( 'change', function () {
        $.publish('accuracyChange', this.value);
      });
    }
  };

  ROG.pensionPotAccuracy = pensionPotAccuracy;

})(jQuery);
