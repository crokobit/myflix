require 'spec_helper'

describe UsersController do

  let(:user) { Fabricate(:user) }
  
  describe "users#new" do
    it "assigns a new User obj to @user" do
      get :new
      expect(assigns(:user)).to be_a_new User
    end
  end

  describe "users#create#mailer" do
    before do
      stripe_response = double(:stripe_response, successful?: true)
      StripeWrapper::Charge.stub(:create).and_return(stripe_response)
      post :create,user: { name: "crokobit", password: "pw", email: "cererkobit@gmail.com" }
    end
    it "sends email to user" do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end
    it "sends to user's email" do
      expect(ActionMailer::Base.deliveries.last.to).to eq ["cererkobit@gmail.com"]
    end
  end
  
  describe "users#create" do
    context "valid user information and valid card information" do
      before do
        stripe_response = double(:stripe_response, successful?: true)
        StripeWrapper::Charge.stub(:create).and_return(stripe_response)
      end
      it "saves user data to db" do
        expect{
          post :create,user: Fabricate.attributes_for(:user)
        }.to change(User, :count).by(1)
      end
      it "redirects to videos_path" do
        post :create,user: { name: "crokobit", password: "pw", email: "crokobit@fdf.ef" }
        expect(response).to redirect_to videos_path
      end
    end

    context "invalid user information and valid card information" do
      before do
        stripe_response = double(:stripe_response, successful?: true)
        StripeWrapper::Charge.stub(:create).and_return(stripe_response)
      end
      it "renders :new" do
        post :create ,user: Fabricate.attributes_for(:invalid_user)
        expect(response).to render_template :new 
      end
      it "should have no charge" do
        StripeWrapper::Charge.should_not_receive(:create)
        post :create ,user: Fabricate.attributes_for(:invalid_user)
      end
    end

    context "valid user information and invalid card information" do
      before do
        stripe_response = double(:stripe_response, successful?: false)
        StripeWrapper::Charge.stub(:create).and_return(stripe_response)
      end
      it "do not create user" do
        expect{
          post :create,user: Fabricate.attributes_for(:user)
        }.to change(User, :count).by(0)
      end
      it "render :new" do
        post :create,user: Fabricate.attributes_for(:user)
        expect(response).to render_template :new 
      end
      
    end

    context "create user through invite with valid card" do
      before do
        token = double(:token, successful?: true)
        StripeWrapper::Charge.stub(:create).and_return(token)
      end
      it "destroys all InviteUser link inviting the user" do
        invite_user = Fabricate(:invite_user, invitor: user)
        new_user_attributes = {
          name: Faker::Name.name,
          password: Faker::Internet.password,
          email: invite_user.recipient_email
        } 
        post :create, user: new_user_attributes, token: invite_user.token
        new_user = User.find_by(email: invite_user.recipient_email)
        expect(InviteUser.where(recipient_email: invite_user.recipient_email).count).to be 0 
      end
      it "sets follow each other relationship" do
        invite_user = Fabricate(:invite_user, invitor: user)
        new_user_attributes = {
          name: Faker::Name.name,
          password: Faker::Internet.password,
          email: invite_user.recipient_email
        } 
        post :create, user: new_user_attributes, token: invite_user.token
        new_user = User.find_by(email: invite_user.recipient_email)
        expect(user.following_users).to include new_user
        expect(user.followed_me_users).to include new_user
      end
      it "create user successful after retry" do
        # I don;t know how to test this
      end
    end
  end

  describe "users#update" do

    it "locates requested user to @user" do
      patch :update, id: user ,user: { 
        name: user.name,
        password: "pw",
        email: user.email,
      }
      expect(assigns(:user)).to eq user
    end

    context "valid update" do
      before(:each) do
        patch :update, id: user ,user: { 
          name: "crokobit",
          password: "pw",
          email: "crokobit@gmail.com"
        }
        user.reload
      end
      it "updates @user to db" do
        expect(user.name).to eq "crokobit"
        expect(user.authenticate("pw")).to eq user
        expect(user.email).to eq "crokobit@gmail.com"
      end
      it "redirects to root_path" do
        expect(response).to redirect_to root_path
      end
    end

    context "invalid update" do
      before(:each) do
        patch :update, id: user ,user: { 
          name: "",
          password: "pw",
          email: "crokobit@gmail.com"
        }
      end
      it "render :edit" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "users#show" do
    it_behaves_like "require_sign_in" do 
      let(:action) {
        get :show, id: user
      }
    end
    it "assigns a user to @user" do
      set_current_user
      user_query = Fabricate(:user)
      get :show, id: user_query
      expect(assigns(:user)).to eq user_query
    end
  end

  describe "users#new_user_via_invitation" do
    before do
      set_current_user
      @invitor = user
      @invite_user = Fabricate(:invite_user, invitor: @invitor)
      get :new_user_via_invitation, token: @invite_user.token
    end
    it "finds InviteUser" do
      expect(assigns(:invite_user)).to eq @invite_user
    end
    it "prefills email" do
      expect(assigns(:user).email).to eq @invite_user.recipient_email
    end
    it "render 'users/_form_partial'" do
      expect(response).to render_template '_form_partial'  
    end
  end
end
