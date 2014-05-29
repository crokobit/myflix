require 'spec_helper'

describe User do
  let(:user) { Fabricate(:user) }

  context "have_pw_reset?" do
    it "returns true if have pw_reset" do
      PwReset.create(user: user)
      expect(user.have_pw_reset?).to be_true
    end
    it "returns false if have pw_reset" do
      expect(user.have_pw_reset?).to be_false
    end
  end

  context "create_pw_reset" do
    it "creates new pw_reset if already exist" do
      old = PwReset.create(user: user)
      user.create_pw_reset
      user.reload
      expect(user.pw_reset).to_not eq old
      expect(user.pw_reset).to be_instance_of(PwReset)
    end
    it "creates new pw_reset" do
      user.create_pw_reset
      user.reload
      expect(user.pw_reset).to be_instance_of(PwReset)
    end
  end

  context "change_pw_to(pw)" do
    before do
      User.all.map(&:destroy)
      #WHY QQQQQQ
    end
    it"returns true if changing password successfully" do
      expect(user.change_pw_to "crokobit").to be_true
    end
    it "changes password to new password" do
      old_pw = user.password
      user.change_pw_to "new_pw"
      expect(User.first.authenticate('new_pw')).to be_true
    end
    it"returns false if changing password fail" do
      expect(user.change_pw_to nil).to be_false
    end
  end

  context "folllow relationship" do
    let(:followed) { Fabricate(:user) }
    it "is_following(followed) sets self following another user" do
      user.is_following(followed)        
      expect(user.following_users).to include followed
    end
    it "following_each_other_with(another_user)" do
      user.following_each_other_with(followed)
      expect(user.following_users).to include followed
      expect(user.followed_me_users).to include followed
    end
  end

  context "can follow another user or not" do
    it "returns false if going to follow self" do
      expect(user.can_follow?(user)).to be_false
    end
    it "returns false if already following another user" do
      followed = Fabricate(:user)
      FollowRelationship.create(follower: user, followed: followed)
      expect(user.can_follow?(followed)).to be_false
    end
  end
end
