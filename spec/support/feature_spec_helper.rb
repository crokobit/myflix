
  def sign_in
    visit root_path
    click_link "Sign In"
    fill_in 'Name', with: @user.name
    fill_in 'Password', with: @user.password
    click_button "Login"
  end
  
  def click_video(id)
      visit videos_path
      find("a[href='/videos/#{id}']").click
  end

