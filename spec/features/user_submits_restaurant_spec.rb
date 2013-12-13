require 'spec_helper'
feature 'user creates an event', %q{
  As a user 
  I want to create a restaurant so that 
  my restaurant can be a part of the SafeFare Web Service. 
} do
 # Acceptance Criteria:
  # * I must be logged in
  it 'logs in. redirects. sees its restaurants. clicks add restaurant.' do
    user = User.find(12) 
    visit root_path
    click_on 'Login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_on 'Sign in'
    click_on 'Add A New Restaurant'
  end



end


