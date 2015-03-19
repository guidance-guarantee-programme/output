(function ($) {
  'use strict';

  window.PWO = window.PWO || {};

  var pensionPotAccuracy = {
    init: function () {
      this.insertHTML();
      this.cache();
      this.bindEvents();
    },
    insertHTML: function () {
      var html = $('#pension_pot_accuracy').text();
      $('#col-pension-pot-value').before(html);
    },
    cache: function () {
      this.$input = $('input[name="appointment_summary[accuracy]"]');
    },
    bindEvents: function () {
      this.$input.on('change', function () {
        $.publish('accuracyChange', this.value);
      });
    }
  };

  PWO.pensionPotAccuracy = pensionPotAccuracy;

})(jQuery);
