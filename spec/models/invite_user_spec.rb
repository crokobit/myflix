require 'spec_helper'

describe InviteUser do
  describe "set_up_relationship sets up following each other relationship" do
    before do
      @invitor = Fabricate(:user)      
      @recipient = Fabricate(:user)
      @invite_user = InviteUser.create(invitor: @invitor, recipient_email: @recipient.email)
      @invite_user.set_up_relationship
    end
    it "sets up invitor follows recipient relationship" do
      expect(@invitor.following_users).to include @recipient
    end
    it "sets up recipient follows invitor relationship" do
      expect(@invitor.followed_me_users).to include @recipient
    end
  end


  describe "destroy_all_invitations_to(email)" do
    it "destroys all invitations to sb. " do
      InviteUser.delete_all
      user = Fabricate(:user)
      @invite_user = Fabricate(:invite_user, invitor: user)
      @invite_user2 = Fabricate(:invite_user, invitor: user, recipient_email: @invite_user.recipient_email)
      InviteUser.destroy_all_invitations_to(@invite_user.recipient_email)
      expect(InviteUser.count).to be 0
    end      
  end
end
