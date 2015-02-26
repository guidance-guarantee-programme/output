class StyleguideController < ApplicationController
  def index
  end

  def base
  end

  def pages_input
    render template: 'styleguide/pages/input'
  end

  def pages_output
    respond_to do |format|
      format.pdf do
        render pdf: 'pension_wise', encoding: 'utf-8', template: 'styleguide/pages/output'
      end
    end
  end
end
