(function ($) {
  'use strict';

  window.PWO = window.PWO || {};

  var pensionPotAccuracy = {
    init: function () {
      this.insertHTML();
      this.cache();
      this.bindEvents();
      this.subscribe();
    },
    insertHTML: function () {
      var html = $('#pension-pot-accuracy').html();
      $('#col-pension-pot-value').before(html);
    },
    cache: function () {
      this.$input = $('input[name="appointment_summary[accuracy]"]');
      this.$valueOfPensionPotsIsApproximate = $('input[name="appointment_summary[value_of_pension_pots_is_approximate]"]');
    },
    bindEvents: function () {
      this.$input.on('change', function () {
        $.publish('accuracyChange', this.value);
      });
    },
    subscribe: function() {
      var that = this;
      $.subscribe('accuracyChange', function (e, value) {
        var valueIsApproximate = (value === 'approximate');
        that.$valueOfPensionPotsIsApproximate.prop('checked', valueIsApproximate);
      });
    }
  };

  PWO.pensionPotAccuracy = pensionPotAccuracy;

})(jQuery);
