class PreviewPage < SitePrism::Page
  set_url_matcher %r{/appointment_summaries/preview}

  element :name, '.name'
  element :confirm, '.t-confirm'
  element :back, '.t-back'
end
