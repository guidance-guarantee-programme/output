module CountriesHelper
  def prioritised_country_list
    [Countries.uk] | Countries.all
  end
end
