require 'spec_helper'

feature "user signs in" do
  background do
  end
  scenario "with right username and password" do
    @user = Fabricate(:user)
    sign_in(@user)
    expect(page).to have_content @user.name
  end
  scenario "regisiter" do
    user = Fabricate.build(:user)
    visit root_path
    click_link "Sign Up Now!"
    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Full Name', with: user.name
    click_button "Sign Up"
    expect(User.count).to eq 1
  end
end
