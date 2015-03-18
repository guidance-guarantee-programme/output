(function ($) {
  'use strict';

  window.PWO = window.PWO || {};

  var pensionPotPreview = {
    accuracy: 'exact',
    value1: '',
    value2: '',
    init: function () {
      this.insertHTML();
      this.cache();
      this.subscribe();
    },
    insertHTML: function () {
      var html = $('#pension_pot_preview').text();
      $('#col-pension-pot-value').append(html);
    },
    cache: function () {
      this.$output = $('.preview__amount');
    },
    subscribe: function () {
      var that = this;
      $.subscribe('accuracyChange', function (e, value) {
        that.accuracy = value;
        that.update();
      });
      $.subscribe('valueChange', function (e, value, id) {
        if (id === 'appointment_summary_value_of_pension_pots') {
          that.value1 = value;
        } else {
          that.value2 = value;
        }
        that.update();
      });
    },
    update: function () {
      var displayText;
      var val1 = this.value1;
      var val2 = this.value2;

      if (this.accuracy === 'notprovided') {
        displayText = 'No value provided';
      } else {
        if (val1 === '') {
          displayText = '£';
        } else if ((val1 !== '') && (val2 !== '')) {
          displayText = '£' + val1 + ' to £' + val2;
        } else {
          displayText = '£' + val1;
        }
        if (this.accuracy === 'approximate') {
          displayText = displayText + ' (approximately)';
        }
      }

      this.$output.text(this.replaceNumberWithCommas(displayText));
    },
    replaceNumberWithCommas: function (num) {
      return num.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    }
  };

  PWO.pensionPotPreview = pensionPotPreview;

})(jQuery);
