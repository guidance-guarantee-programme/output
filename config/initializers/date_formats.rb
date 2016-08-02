# frozen_string_literal: true
# https://www.gov.uk/service-manual/user-centred-design/resources/patterns/dates.html#formatting-dateso

Date::DATE_FORMATS[:pw_date_long] = '%A, %-d %B %Y'

Date::DATE_FORMATS[:gov_uk] = '%-d %B %Y'

default = { default: '%d/%m/%Y' }
Time::DATE_FORMATS.merge!(default)
Date::DATE_FORMATS.merge!(default)
