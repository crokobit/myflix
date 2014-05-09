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
end
