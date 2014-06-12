require 'spec_helper'

feature "add video" do
  scenario "add video" do
    user = User.create(name: "crokobit", password: "pw", email: "crokobit@gmail.com", admin: true)
    category = Fabricate(:category)
    video = Fabricate.build(:video)
    sign_in(user)
    visit '/admin/videos/new'


    fill_in 'Title', with: video.title
    select category.name, from: 'Category'
    fill_in 'Description', with: video.description
    attach_file "Large cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small cover", "spec/support/uploads/monk.jpg"
    fill_in 'Video URL', with: video.url
    click_button "Add Video"
    sign_out
    sign_in
    click_video(1)
    save_and_open_page
    expect(page).to have_selector "img[src='/uploads/video/large_cover/1/monk_large.jpg']"
    expect(page).to have_selector "a[href='#{video.url}']"
  end

  def click_video(id)
      visit videos_path
      find("a[href='/videos/#{id}']").click
  end
end

