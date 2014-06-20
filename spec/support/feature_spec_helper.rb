
  def sign_in(a_user=nil)
    user = a_user || Fabricate(:user)
    visit root_path
    click_link "Sign In"
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button "Login"
  end

  def sign_out
    click_link "Sign Out"
  end
  
  def click_video(id)
      visit videos_path
      find("a[href='/videos/#{id}']").click
  end

