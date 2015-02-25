class StyleguideController < ApplicationController
  def index
  end

  def base
  end

  def pages_input
    render template: 'styleguide/pages/input'
  end

  def pages_output
    render template: 'styleguide/pages/output'
  end
end
