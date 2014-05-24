require 'spec_helper'

feature "invite user" do
  scenario "invite user" do
    @invitor = Fabricate(:user)   
    @user = Fabricate.build(:user)
    sign_in(@invitor)
    visit '/send_invite_email'
    fill_in "Friend's Email Address", with: @user.email
    fill_in "Friend's Name", with: @user.name
    click_button "Send Invitation"

    open_email(@user.email)
    current_email.click_link("invitation")
    
    fill_in 'Email Address', with: @user.email
    fill_in 'Password', with: @user.password
    fill_in 'Full Name', with: @user.name
    click_button "Sign Up"


    visit '/people'
    save_and_open_page
    expect_followed_user_to_be_in_the_queue(@invitor)
  end

  def expect_followed_user_to_be_in_the_queue(user)
    expect(page).to have_content user.name
  end
end
