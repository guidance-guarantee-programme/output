class StyleguideController < ApplicationController
  def index
  end

  def pages_input
    render template: 'styleguide/pages/input'
  end

  def pages_output_elements
    render template: 'styleguide/pages/output_elements'
  end
end
