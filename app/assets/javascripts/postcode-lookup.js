(function ($) {
  'use strict';

  window.PWO = window.PWO || {};

  var postcodeLookup = {
    init: function () {
      this.postcode = document.getElementById('autocomplete-postcode');
      this.clear = $('#postcode-reset');
      this.autocomplete = new google.maps.places.Autocomplete(this.postcode, { types: ['geocode'], componentRestrictions: {country: 'uk'} });

      this.initAutoComplete();
      this.clear.on('click', this.clearAddress.bind(this));
    },

    initAutoComplete: function () {
      this.autocomplete.setFields(['address_components']);
      google.maps.event.addListener(this.autocomplete, 'place_changed', this.onPlaceChanged.bind(this));
    },

    clearAddress: function() {
      var addressFields = [
        '#appointment_summary_address_line_1',
        '#appointment_summary_address_line_2',
        '#appointment_summary_address_line_3',
        '#appointment_summary_town',
        '#appointment_summary_county',
        '#appointment_summary_postcode'
      ];

      this.postcode.value = '';

      for(var i = 0; i < addressFields.length; i++) {
        $(addressFields[i]).val('');
      }
    },

    onPlaceChanged: function() {
      var place = this.autocomplete.getPlace();
      var components = { postal_town: '#appointment_summary_town', postal_code: '#appointment_summary_postcode' };

      if(place.address_components) {
        place = place.address_components;

        $('#appointment_summary_address_line_1').val(place[0].long_name + ' ' + place[1].long_name);

        for (var i = 2; i < place.length; i++) {
          var addressType = place[i].types[0];

          if (components[addressType]) {
            $(components[addressType]).val(place[i].long_name);
          }
        }
      }
    },
  };

  PWO.postcodeLookup = postcodeLookup;

})(jQuery);
