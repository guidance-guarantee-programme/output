(function ($) {
  'use strict';

  window.PWO = window.PWO || {};

  var pensionPotInput = {
    init: function () {
      this.insertHTML();
      this.cache();
      this.subscribe();
      this.bindEvents();
    },
    insertHTML: function () {
      var html = $('#pension-pot-input-error').html();
      $('.display_if_range').after(html);
    },
    cache: function () {
      this.$wrapper = $('.display_if_range');
      this.$inputs = $('.js-numbers-only');
      this.$input1 = $('#appointment_summary_value_of_pension_pots');
      this.$input2 = $('#appointment_summary_upper_value_of_pension_pots');
    },
    subscribe: function () {
      var that = this;
      $.subscribe('accuracyChange', function (e, value) {
        if (value === 'range') {
          that.$wrapper.fadeIn();
        } else {
          that.$wrapper.fadeOut();
          that.$input2.val('');
          that.$input2.trigger('keyup');
        }

        if (value === 'notprovided') {
          that.$input1.val('');
          that.$input1.trigger('keyup');
          that.$input2.val('');
          that.$input2.trigger('keyup');
        }
      });

      $.subscribe('eligibilityChange', function (e, value) {
        if (value === 'no') {
          that.$input1.val('');
          that.$input1.trigger('keyup');
          that.$input2.val('');
          that.$input2.trigger('keyup');
        }
      });
    },
    bindEvents: function () {
      this.$inputs.on('keypress', function (e) {
        //if the letter is not digit then display error and don't type anything
        if (e.which !== 8 && e.which !== 0 && (e.which < 48 || e.which > 57)) {
          //display error message
          var error_input = $(e.target).parents('.form-group').find('.js-error-message');
          error_input.html('Only use numbers').show().attr('aria-live', 'polite').fadeOut('slow');
          return false;
        }
      });
    }
  };

  PWO.pensionPotInput = pensionPotInput;

})(jQuery);
