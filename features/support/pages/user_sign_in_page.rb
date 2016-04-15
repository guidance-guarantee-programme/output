class UserSignInPage < SitePrism::Page
  set_url '/users/sign_in'
  set_url_matcher %r{/users/sign_in}

  element :email, '.t-email'
  element :password, '.t-password'
  element :submit, '.t-submit'

  def login(user)
    load unless displayed?

    email.set user.email
    password.set user.password
    submit.click
  end
end
