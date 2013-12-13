module SignInHelper

  def sign_in_as(user)
    visit root_path
    click_on 'sign in'
    binding.pry
    fill_in 'login-name', with: user.email
    fill_in 'login-pass', with: user.password
    click_on 'Sign in'
  end

end