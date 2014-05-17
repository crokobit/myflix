require 'spec_helper'
feature "reset password spec" do
  background do
    clear_emails
  end

  scenario "reset password spec" do
    user = Fabricate(:user)
    visit root_path
    click_link "Sign In"
    click_link "Forget Password"
    fill_in 'Email Address', with: user.email
    click_button 'Send Email'
    open_email(user.email)
    current_email.click_link("Reset Password")
    fill_in 'New Password', with: "pw"
    click_button "Reset Password"
    user.update(password: "pw")
    sign_in(user)
    expect(page).to have_content user.name 
  end
end
