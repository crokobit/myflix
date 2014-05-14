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
      post :create,user: { name: "crokobit", password: "pw", email: "cererkobit@gmail.com" }
    end
    it "send email to user" do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end
    it "send to user's email" do
      expect(ActionMailer::Base.deliveries.last.to).to eq ["cererkobit@gmail.com"]
    end
  end
  
  describe "users#create" do
    context "user data pass validation" do
      it "save user to db" do
        expect{
          post :create,user: Fabricate.attributes_for(:user)
        }.to change(User, :count).by(1)
      end
      it "redirects to videos_path" do
        post :create,user: { name: "crokobit", password: "pw", email: "crokobit@fdf.ef" }
        expect(response).to redirect_to videos_path
      end
    end

    context "user data does not pass validation" do
      it "renders :new" do
        post :create ,user: Fabricate.attributes_for(:invalid_user)
        expect(response).to render_template :new 
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
end
