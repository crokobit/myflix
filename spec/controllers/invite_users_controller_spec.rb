require 'spec_helper'

describe InviteUsersController do
  describe "invite_users#new" do
    let(:user) {Fabricate(:user)}
    before do
      set_current_user
      get :new
    end
    it_behaves_like "require_sign_in" do
      # good or bad order after before do? maybe this order will puzzle reader?
      let(:action) {get :new}
    end
    it "creates new InviteUser object @invite_user" do
      expect(assigns(:invite_user)).to be_a_new InviteUser
    end
  end
  describe "invite_users#create" do
    let(:user) {Fabricate(:user)}
    context "require login" do
      let(:user) {Fabricate(:user)}
      before do
        InviteUser.delete_all
        #WHY ?????
        set_current_user
        @invitor = user
        @invite_user = Fabricate(:invite_user, invitor: @invitor)
        post :create, invite_user: {
          recipient_name: @invite_user.recipient_name,
          recipient_email: @invite_user.recipient_email,
          recipient_message: @invite_user.recipient_message 
        }
      end
      it "creates @invite_user" do
        expect(assigns(:invite_user)).to be_instance_of InviteUser
      end
      it "assigns values to a @invite_user" do
        expect(assigns(:invite_user).recipient_name).to eq @invite_user.recipient_name 
      end
      it "assigns invitor to a @invite_user" do
        expect(assigns(:invite_user).invitor).to eq @invitor
      end
      it "save to db" do
        expect(InviteUser.count).to eq 2
      end
      it "sends invitation letter to" do
        expect(ActionMailer::Base.deliveries.last.to).to eq [assigns(:invite_user).recipient_email]
      end
      it "sends invitation letter with link" do
        expect(ActionMailer::Base.deliveries.last.body.raw_source).to include assigns(:invite_user).token
      end
      it "redirects to invitation success page" do
        expect(response).to render_template 'invitation_success'
      end
  end

    it "render :new if recipient already regisitered" do
      set_current_user
      invitor = user
      registered_user = Fabricate(:user)
      invite_user = Fabricate(:invite_user, invitor: invitor)
      post :create, invite_user: {
        recipient_name: invite_user.recipient_name,
        recipient_email: registered_user.email,
        recipient_message: invite_user.recipient_message 
      }
      expect(response).to render_template :new
    end
    it_behaves_like "require_sign_in" do
      # good or bad order after before do? maybe this order will puzzle reader?
      let(:action) {
        post :create, invite_user: Fabricate.attributes_for(:invite_user)
      }
    end
  end

  describe "invite_users#show (email link to here)" do
    let(:user) {Fabricate(:user)}
    before do
      @invitor = user
      @invite_user = Fabricate(:invite_user, invitor: @invitor)
    end
    it "redirects to root_path when link is expired" do
      token = @invite_user.token
      @invite_user.destroy 
      get :show, id: token
      expect(response).to redirect_to root_path
    end
    it "redirects to users#new_user_via_invitation if token is not expire" do
      get :show, id: @invite_user
      expect(response).to redirect_to new_user_via_invitation_path(token: @invite_user)
    end
  end

end
