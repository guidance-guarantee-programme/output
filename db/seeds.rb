User.find_or_create_by!(name: 'Joe Bloggs', email: 'joe.bloggs@pensionwise.gov.uk') do |user|
  user.permissions = [
    'signin',
    'team_leader',
    'analyst'
  ]
end
