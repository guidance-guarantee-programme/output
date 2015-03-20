//= require jquery.postcodes/dist/postcodes.min.js

(function ($) {
  'use strict';

  window.PWO = window.PWO || {};

  var postcodeLookup = {
    init: function () {
      this.insertHTML();
      this.initPostcodeLookup();
    },
    insertHTML: function () {
      var html = $('#postcode-lookup-template').text();
      $('#postal-address-heading').after(html);
    },
    initPostcodeLookup: function() {
      $('#postcode-lookup').setupPostcodeLookup({
        address_search: 20,
        api_key: 'iddqd',
        input: '#postcode-lookup-input',
        button: '#postcode-lookup-button',
        dropdown_class: 'form-control input-md-3',
        dropdown_container: '#postcode-lookup-results-container',
        output_fields: {
          line_1: '#appointment_summary_address_line_1',
          line_2: '#appointment_summary_address_line_2',
          line_3: '#appointment_summary_address_line_3',
          post_town: '#appointment_summary_town',
          county: '#appointment_summary_county',
          postcode: '#appointment_summary_postcode'
        }
      });
    }
  };

  PWO.postcodeLookup = postcodeLookup;

})(jQuery);
