require 'spec_helper'

describe Admin::VideosController do
  describe "admin/videos#new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end
    it_behaves_like "require_admin" do
      let(:user) { Fabricate(:user, admin: false)}
      let(:action) { get :new }
    end
    it "creates new video object" do
      user = Fabricate(:user, admin: true)
      session[:user_id] = user.id
      # WHY set_current_user can not work ??!! sth about let syntax??
      # let scope problem?
      get :new
      expect(assigns(:video)).to be_instance_of Video
    end

    describe "admin/videos#create" do
      it "create new video if data all valid"
    end
  end
end
