require 'spec_helper'

describe FollowRelationshipsController do
  context "follow_relationship#destroy" do
    let(:user) { Fabricate(:user) }
    let(:followed) { Fabricate(:user) }
    before do
      set_current_user
      @relationship = FollowRelationship.create(follower: user, followed: followed)
    end
    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: followed }
    end
    it "find out the relationship we want to delete" do
      delete :destroy, id: followed
      expect(assigns(:relationship)).to eq @relationship
    end
    it "delete the relationship" do
      delete :destroy, id: followed
      expect(FollowRelationship.count).to eq 0
    end
  end

  context "follow_relationship#create" do
    let(:user) { Fabricate(:user) }
    let(:followed) { Fabricate(:user) }
    before do
      set_current_user
    end
    it_behaves_like "require_sign_in" do
      let(:action) { post :create, id: followed } 
    end
    it "save relationship to db if it is valid input" do
      post :create, id: followed
      expect(FollowRelationship.count).to eq 1
    end
    it "redirect_to people_path when successfully saving data" do
      post :create, id: followed
      expect(response).to redirect_to user_path(followed)
    end
    it "redirects to users#show when fail" do
      FollowRelationship.create(follower: user, followed: followed)
      post :create, id: followed
      expect(response).to redirect_to user_path(followed)
    end
  end
end
