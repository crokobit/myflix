require 'spec_helper'

describe PwResetsController do

  context "pw_resets#create" do
    context "invalid email" do
      it "renders :enter_email if can not find user via email" do
        post :create, email: "XXX.xx.x"
        expect(response).to render_template :enter_email
      end
    end
    
    context "valid email" do
      let(:user) { Fabricate(:user) }
      before do
        post :create, email: user.email
      end
      it "creates pw_reset(token)" do
        expect(user.pw_reset).to_not be_nil
      end
      it "sends email" do
        expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
      end
      it "has reset password link" do
        user.reload
        expect(ActionMailer::Base.deliveries.last.body.raw_source).to include user.pw_reset.token
      end
      it "render 'enter mail success page'" do
        expect(response).to render_template 'enter_email_success'
      end
    end
  end

  context "pw_resets#show" do
    let(:user) { Fabricate(:user) }
    before do
      user.create_pw_reset
      user.reload
      get :show, id: user.pw_reset.token
    end
    context "valid pw_reset.token id" do
      it "sets @user by token" do
        expect(assigns(:user)).to eq user
      end
      it "render reset_pw if find user via token" do
        expect(response).to render_template 'reset_pw'
      end
    end
    context "invalid pw_reset.token id"
    it "redirect to root_path if can not find user via token" do
      get :show, id: "frfrfr"
      expect(response).to redirect_to root_path
    end
  end

  context "pw_resets#reset_pw" do
    let(:user) { Fabricate(:user) }
    context "pw valid" do
      before do
        User.all.map(&:destroy)
        #WHY QQQQQQ
        user.create_pw_reset
        user.reload
        get :reset_pw, token: user.pw_reset.token, password: "new_pw"
      end
      it "changes user's pw" do
        expect(User.first.authenticate("new_pw")).to_not be_false
      end
      it "destroys token(pw_reset)"  do
        expect(User.first.pw_reset).to be_nil      
      end
      it "redirects to root_path" do
        expect(response).to redirect_to root_path
      end
    end

    context "pw invalid" do
      it "redirects to pw reset path with token" do
        user.create_pw_reset
        user.reload
        get :reset_pw, token: user.pw_reset.token, password: ""
        expect(response).to redirect_to pw_reset_path(user.pw_reset)
      end
    end
  end

end
