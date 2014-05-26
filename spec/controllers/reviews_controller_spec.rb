require 'spec_helper'

describe ReviewsController do

  let(:user)  { Fabricate(:user) }
  let(:video) { Fabricate(:video) }

  describe "reviews#create" do
    context "logged in" do
      context "data pass validation" do
        before(:each) do
          set_current_user
          @review = Fabricate.build(:review)
          post :create,  video_id: video.id, review: { rating: @review.rating, review_description: @review.review_description }
        end
        it "assigns rating to @review" do
          expect(assigns(:review).rating).to eq @review.rating
        end
        it "assigns review_description to @review" do
          expect(assigns(:review).review_description).to eq @review.review_description
        end
        it "assigns video to @review" do
          expect(assigns(:review).video).to eq video
        end
        it "assigns current user to @review" do
          expect(assigns(:review).user).to eq user
        end
        it "save reviews to db when validation success" do
          expect(Review.count).to eq 1
        end
        it "redirect_to videos#show " do
          expect(response).to redirect_to video
        end
      end
      
      context "data not pass validation" do
        before(:each) do
          set_current_user
          @review = Fabricate.build(:review)
        end
        it "shows alert message : when user already voted" do
          post :create, video_id: video.id, review: { rating: @review.rating, review_description: @review.review_description }
          post :create, video_id: video.id, review: { rating: @review.rating, review_description: @review.review_description }
          expect(flash[:danger]).to eq "Can not rating twice !!"
        end
        it "does not save review to db when user already voted" do
          post :create, video_id: video.id, review: { rating: @review.rating, review_description: @review.review_description }
          expect{
            post :create, video_id: video.id, review: { rating: @review.rating, review_description: @review.review_description }
          }.to change{Review.count}.by 0
        end
        it "shows alert message : when user do not give rating" do
          post :create, video_id: video.id, review: { rating: nil, review_description: "" }
          expect(flash[:danger]).to eq "must give rating"
        end
        it "does not save review to db when user do not give rating" do
          expect(Review.count).to eq 0
        end
      end
    end  

    context "not logged in" do
      before(:each) do
        @review = Fabricate.build(:review)
        post :create, video_id: video.id, review: { rating: @review.rating, review_description: @review.review_description }
      end

      it "does not save rview to db" do
        expect(Review.count).to eq 0
      end

      it_behaves_like "require_sign_in"

    end
  end

end
