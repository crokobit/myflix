require 'spec_helper'

feature "user signs in" do
  background do
  end
  scenario "regisiter" do
    @user = Fabricate(:user)
    sign_in
    expect(page).to have_content @user.name
  end
  scenario "with right username and password" do
    user = Fabricate(:user)
    visit root_path
    click_link "Sign Up Now!"
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button "submit"
    expect(User.first).to eq user
  end
end
