require 'spec_helper'

feature "user signs in" do
  scenario "with right username and password, active user", :js do
    @user = Fabricate(:user)
    sign_in(@user)
    expect(page).to have_content @user.name
  end
  scenario "with right username and password, deactive user", :js do
    @user = Fabricate(:user, active: false)
    sign_in(@user)
    expect(page).to_not have_content @user.name
    expect(page).to have_content "user was deactived"
  end
  scenario "with invalid username and password, deactived user", :js do
    @user = Fabricate(:user, active: false)
    sign_in_with_empty_password(@user)
    expect(page).to_not have_content @user.name
    expect(page).to have_content "Login fail"
  end
end
