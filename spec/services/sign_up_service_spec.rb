require 'spec_helper'

describe SignUpService do
  let(:user) { Fabricate(:user) } 

  describe "mailer" do
    before do
      stripe_response = double(:stripe_response, successful?: true, customer_token: "SS")
      StripeWrapper::Charge.stub(:create).and_return(stripe_response)
    end
    it "sends email to user when sign up successfully" do
      SignUpService.new(user, "test", nil).sign_up
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end
    it "sends to user's email when sign up successfully" do
      SignUpService.new(user, "test", nil).sign_up
      expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
    end
  end

  describe "create user" do
    context "valid user information and valid card information" do
      before do
        stripe_response = double(:stripe_response, successful?: true, customer_token: "asdf")
        StripeWrapper::Charge.stub(:create).and_return(stripe_response)
      end
      it "saves user data to db" do
        expect{
          SignUpService.new(user, "test", nil).sign_up
        }.to change(User, :count).by(1)
      end
      it "saves stripe customer_token" do
        SignUpService.new(user, "test", nil).sign_up
        expect(User.first.customer_token).to eq "asdf"
      end
    end

    context "invalid user information and valid card information" do
      before do
        stripe_response = double(:stripe_response, successful?: true)
        StripeWrapper::Charge.stub(:create).and_return(stripe_response)
      end
      it "should have no charge" do
        StripeWrapper::Charge.should_not_receive(:create)
        SignUpService.new(Fabricate.build(:invalid_user), "test", nil).sign_up
      end
    end

    context "valid user information and invalid card information" do
      before do
        stripe_response = double(:stripe_response, successful?: false)
        StripeWrapper::Charge.stub(:create).and_return(stripe_response)
      end
      it "do not create user" do
        @user = Fabricate(:user)
        expect{
          SignUpService.new(@user, "test", nil).sign_up
          #using user defined by let will cause test think user creation occured in this block.
        }.to change(User, :count).by(0)
      end
      
    end

    context "create user through invite with valid card" do
      before do
        token = double(:token, successful?: true, customer_token: "SS")
        StripeWrapper::Customer.stub(:create).and_return(token)
      end
      it "destroys all InviteUser link inviting the user" do
        invite_user = Fabricate(:invite_user, invitor: user)
        new_user = Fabricate(:user, email: invite_user.recipient_email)
        SignUpService.new(new_user, "test", invite_user.token).sign_up
        expect(InviteUser.where(recipient_email: invite_user.recipient_email).count).to be 0 
      end
      it "sets follow each other relationship" do
        invite_user = Fabricate(:invite_user, invitor: user)
        new_user = Fabricate(:user, email: invite_user.recipient_email)
        SignUpService.new(new_user, "test", invite_user.token).sign_up
        expect(user.following_users).to include new_user
        expect(user.followed_me_users).to include new_user
      end
    end
  end
end
