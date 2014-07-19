
require 'spec_helper'

feature "register", {js: true, vcr: true} do
  let(:valid_user) { Fabricate.build(:user) }
  let(:invalid_user) { Fabricate.build(:invalid_user)}
  background do
    visit root_path
    click_link "Sign Up Now!"
  end
  scenario "valid user valid card" do
    fill_in_user_information(valid_user)
    fill_in_with_valid_card
    click_button "Sign Up"
    expect(page).to have_content "Unlimited Movies"
    #sign in will fail without code above
    #https://github.com/jnicklas/capybara#asynchronous-javascript-ajax-and-friends
    sign_in(valid_user)
    expect(page).to have_content valid_user.name
    #below test will fail without code above
    #https://github.com/jnicklas/capybara#asynchronous-javascript-ajax-and-friends
    expect(User.count).to eq 1
  end
  scenario "valid user declined card" do
    fill_in_user_information(valid_user)
    fill_in_with_declined_card
    click_button "Sign Up"
    expect(page).to have_content "user information is valid but card is invalid"
  end
  scenario "valid user invalid card" do
    fill_in_user_information(valid_user)
    fill_in_with_invalid_card
    click_button "Sign Up"
    # js
    expect(page).to have_content "Your card number is incorrect."
  end
  scenario "invalid user valid card" do
    fill_in_user_information(invalid_user)
    fill_in_with_valid_card
    click_button "Sign Up"
    # rails
    expect(page).to have_content "user information is invalid"
  end
  scenario "invalid user declined card" do
    fill_in_user_information(invalid_user)
    fill_in_with_declined_card
    click_button "Sign Up"
    expect(page).to have_content "user information is invalid"
  end
  scenario "invalid user invalid card" do
    fill_in_user_information(invalid_user)
    fill_in_with_invalid_card
    click_button "Sign Up"
    #js
    expect(page).to have_content "Your card number is incorrect."
  end
end
