require 'spec_helper'

describe FollowRelationshipsController do
  context "follow_relationship#destroy" do
    let(:user) { Fabricate(:user) }
    let(:followed) { Fabricate(:user) }

    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: followed }
    end
    it "finds out the relationship we want to delete" do
      set_current_user
      @relationship = FollowRelationship.create(follower: user, followed: followed)
      delete :destroy, id: followed
      expect(assigns(:relationship)).to eq @relationship
    end
    it "deletes the relationship" do
      set_current_user
      @relationship = FollowRelationship.create(follower: user, followed: followed)
      delete :destroy, id: followed
      expect(FollowRelationship.count).to eq 0
    end
    it "can not delete the relationship is current_user is not user following others" do
      set_current_user
      another_user = Fabricate(:user)
      @relationship = FollowRelationship.create(follower: another_user, followed: followed)
      delete :destroy, id: followed
      expect(FollowRelationship.count).to eq 1
    end
  end

  context "follow_relationship#create" do
    let(:user) { Fabricate(:user) }
    let(:followed) { Fabricate(:user) }

    it_behaves_like "require_sign_in" do
      let(:action) { post :create, id: followed } 
    end
    it "saves relationship to db if it is valid input" do
      set_current_user
      post :create, id: followed
      expect(FollowRelationship.first.followed).to eq followed
      expect(FollowRelationship.first.follower).to eq user
    end
    it "redirects to user_path when successfully saving data" do
      set_current_user
      post :create, id: followed
      expect(response).to redirect_to user_path(followed)
    end
    it "redirects to user_path when fail" do
      set_current_user
      FollowRelationship.create(follower: user, followed: followed)
      post :create, id: followed
      expect(response).to redirect_to user_path(followed)
    end
    it "can not follow same user twice" do
      set_current_user
      FollowRelationship.create(follower: user, followed: followed)
      post :create, id: followed
      expect(FollowRelationship.count).to eq 1
    end
    it "validates has direction proverty" do
      session[:user_id] = followed.id
      FollowRelationship.create(follower: user, followed: followed)
      post :create, id: user
      expect(FollowRelationship.count).to eq 2
    end
    it "can not follow self" do
      set_current_user
      post :create, id: user
      expect(FollowRelationship.count).to eq 0
    end
  end
end
