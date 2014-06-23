require 'spec_helper'

feature "user signs in" do
  background do
    #User.all.map(&:destroy)
    #WHY QQQQQQ
  end
  scenario "with right username and password", :js do
    @user = Fabricate(:user)
    sign_in(@user)
    expect(page).to have_content @user.name
  end
  scenario "register", {js: true, vcr: true} do
    user = Fabricate.build(:user)
    visit root_path
    click_link "Sign Up Now!"
    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Full Name', with: user.name
    fill_in_with_valid_card
    click_button "Sign Up"
    expect(page).to have_content user.name
    #below test will fail without code above
    #https://github.com/jnicklas/capybara#asynchronous-javascript-ajax-and-friends
    expect(User.count).to eq 1
  end
  def fill_in_with_valid_card
    fill_in 'Credit Card Number', with:"4242424242424242"
    fill_in 'Security Code', with: "222"
    select '6 - June', from: "date_month"
    select '2015', from: "date_year"
  end
end
