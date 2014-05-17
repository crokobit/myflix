require 'spec_helper'
feature "social networking feature" do
  background do
    @user = Fabricate(:user)
    @followed = Fabricate(:user, name: "ivan")
    sport = Fabricate(:category, name: "sport")
    5.times do
      review = Fabricate(:review, user: @followed)
      Fabricate(:video, category: sport) do
        reviews(count: 1) { review }
      end
    end
  end
  scenario do
    sign_in (@user)
    #sign_in (User.first) can not work ???
    click_video(1)
    click_link "ivan"
    click_link "Follow" #using click_button fail
    visit '/people'
    expect_followed_user_to_be_in_the_queue(@followed)
    click_remove_follow(@followed)
    expect_followed_user_to_not_be_in_the_queue(@followed)
  end

  def expect_followed_user_to_be_in_the_queue(user)
    expect(page).to have_content user.name
  end

  def click_remove_follow(followed)
      find("a[href='/follow_relationships/#{followed.id}']").click
  end

  def expect_followed_user_to_not_be_in_the_queue(user)
    expect(page).to_not have_content user.name
  end
end
