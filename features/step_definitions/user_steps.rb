Given(/^a new, authenticated user$/) do
  email = 'guider@example.com'
  password = 'pensionwise'

  User.create(email: email, password: password, password_confirmation: password).confirm!

  page = UserSignInPage.new
  page.load
  page.email.set email
  page.password.set password
  page.submit.click
end
