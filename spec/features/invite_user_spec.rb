require 'spec_helper'

feature "invite user" do
  before do
    # using  scenario {js: true, vcr: true} will have following failing message. 1. can not find link "Sign Out". 2. can not find "Email Address"
    # Maybe it is problem about async js.
    #
    stripe_response = double(:stripe_response, successful?: true)
    StripeWrapper::Charge.stub(:create).and_return(stripe_response)
  end
  scenario "invite user" do
    @invitor = Fabricate(:user)   
    @user = Fabricate.build(:user)
    sign_in(@invitor)
    visit '/send_invite_email'
    fill_in "Friend's Email Address", with: @user.email
    fill_in "Friend's Name", with: @user.name
    click_button "Send Invitation"
    sign_out
  
    open_email(@user.email)
    current_email.click_link("invitation")
    

    expect(page).to have_content("Email Address")
    
    
    fill_in 'Password', with: @user.password
    fill_in 'Full Name', with: @user.name
    fill_in_with_valid_card
    click_button "Sign Up"


    expect(page).to have_content @user.name
    #if this test pass, we can sure that new user already sign in.

    visit '/people'
    #save_and_open_page
    #however, error message shows that new user did not sign in in this line!! WHY ??

    expect_followed_user_to_be_in_the_queue(@invitor)
  end

  def expect_followed_user_to_be_in_the_queue(user)
    expect(page).to have_content user.name
  end
end
