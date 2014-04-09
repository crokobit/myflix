require 'spec_helper'

describe QueneItem do
  before do
    @user = Fabricate(:user)
    @video = Fabricate(:video)
    @review = Fabricate(:review, user: @user, video: @video)
    @quene_item = QueneItem.create(user: @user, video: @video)
    @quene_item_no_review = Fabricate(:quene_item)
  end
  it "returns video title" do
    expect(@quene_item.video_title).to eq @video.title
  end
  it "returns category's name" do
    expect(@quene_item.category_name).to eq @video.category.name
  end
  it "returns rating when review exist" do
    expect(@quene_item.rating).to eq @review.rating
  end
  it "returns nil when no review" do
    expect(@quene_item_no_review.rating).to eq nil
  end
end
