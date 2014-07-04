require 'spec_helper'

feature "user signs in" do
  scenario "with right username and password", :js do
    @user = Fabricate(:user)
    sign_in(@user)
    expect(page).to have_content @user.name
  end
end
