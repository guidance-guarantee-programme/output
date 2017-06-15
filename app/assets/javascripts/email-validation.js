(function() {
  'use strict';

  window.PWO = window.PWO || {};

  var emailValidation = {
    init: function() {
      var element = $('.js-email-validation');

      if (element.length) {
        this.setup(element);
      }
    },

    setup: function(element) {
      this.$element = element;
      this.$elementWrapper = $('.email-outer');

      this.$element.mailgun_validator({
        api_key: this.$element.data('api-key'),
        api_host: this.$element.data('api-host'),
        in_progress: this.showLoadingSpinner.bind(this),
        success: this.onSuccess.bind(this),
        error: this.onError.bind(this)
      });

      this.insertSuggestionContainer();
      this.insertLoadingSpinner();
    },

    onSuccess: function(data) {
      this.hideLoadingSpinner();

      if (!data.is_valid || data.did_you_mean) {
        this.showSuggestion(data.is_valid, data.did_you_mean);
      } else {
        this.clearSuggestion();
      }
    },

    onError: function(message) {
      this.hideLoadingSpinner();
      this.$suggestionContainer.html(message);
    },

    insertLoadingSpinner: function() {
      if (this.$loadingSpinner) {
        return;
      }

      this.$loadingSpinner = $('<div class="ajax-loader ajax-loader--24px hidden"></div>');
      this.$loadingSpinner.insertAfter(this.$element);
    },

    showLoadingSpinner: function() {
      this.clearSuggestion();
      this.$loadingSpinner.removeClass('hidden');
    },

    hideLoadingSpinner: function() {
      this.$loadingSpinner.addClass('hidden');
    },

    insertSuggestionContainer: function() {
      if (this.$suggestionContainer) {
        return;
      }

      this.$suggestionContainer = $('<div class="form-hint email-suggestion" aria-live="polite" />');
      this.$suggestionContainer.insertAfter(this.$elementWrapper);
    },

    showSuggestion: function(isValid, didYouMean) {
      var messages = [],
          message;

      if (!isValid) {
        messages.push("that doesn't look like a valid address");
      }

      // Null (falsey) if no suggestion
      if (didYouMean) {
        messages.push(
          'did you mean <button class="button-link t-email-suggestion js-populate-suggested-email">' +
          didYouMean +
          '</button>?'
        );
      }

      message = messages.join(', ');
      message = message.charAt(0).toUpperCase() + message.slice(1);

      // Insert the message
      this.$suggestionContainer.html(message);

      // And now add the click behaviour to populate the suggestion
      $('.js-populate-suggested-email').click(function(event) {
        event.preventDefault();

        // Populate the suggestion and then remove the message
        this.$element.val(event.target.innerHTML);
        this.clearSuggestion();
      });
    },

    clearSuggestion: function() {
      this.$suggestionContainer.empty();
    }
  }

  PWO.emailValidation = emailValidation;
})(jQuery);
