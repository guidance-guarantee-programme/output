class StyleguideController < ApplicationController
  def index
  end

  def pages_input
    render template: 'styleguide/pages/input'
  end
end
