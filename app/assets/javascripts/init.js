$(function () {
  'use strict';

  PWO.additionalAppointment.init();
  PWO.consent.init();
  PWO.eligibility.init();
  PWO.emailValidation.init();
  PWO.pensionPotAccuracy.init();
  PWO.pensionPotInput.init();
  PWO.postcodeLookup.init();

  var hasErrors = !!$('.alert-danger').length;
  var isBackFromConfirmation = !!window.location.search;
  var pensionValue1 = PWO.pensionPotInput.$input1.val();
  var pensionValue2 = PWO.pensionPotInput.$input2.val();

  // set up correct UI when displaying form errors and when use has clicked back from confirmation
  if (hasErrors || isBackFromConfirmation) {
    // check consent form so form is displayed
    PWO.consent.$input.trigger('click');

    // ensure fields for eligible users are displayed
    PWO.eligibility.$input.filter(':checked').trigger('change');

    // set accuracy to approximate if selected
    if ($('#appointment_summary_value_of_pension_pots_is_approximate').is(':checked')) {
      PWO.pensionPotAccuracy.$input.filter('[value=approximate]').click();
    }

    // update accuracy and preview if upper value of pension pot provided
    if (pensionValue2) {
      PWO.pensionPotAccuracy.$input.filter('[value=range]').click();
    }
  }
});
