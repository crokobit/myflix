require 'spec_helper'

describe QueuesController do


  describe "queues#create" do
    let(:user)  { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let!(:queue_target) { QueueItem.where(user: user).count + 1 }

    context "logged in" do
      before(:each) do
        set_current_user
        post :create, id: video
      end
      it "sets user relationship" do
        expect(assigns(:queue_item).user).to eq user
      end
      it "sets video relationship" do
        expect(assigns(:queue_item).video).to eq video
      end
      it "sets position as last item" do
        expect(assigns(:queue_item).position).to eq queue_target 
      end
      it "redirects to my_queue_path" do
        expect(response).to redirect_to my_queue_path
      end
      it "creates nothing if already created" do
        expect {
          post :create, id: video
        }.to change(QueueItem, :count).by(0)
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action)  { post :create, user_id: user.id, video_id: video.id }
    end
  end

  describe "queues#destroy" do
    let(:user)  { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let!(:queue_target) { QueueItem.where(user: user).count + 1 }

    context "logged in" do
      let(:queue_item) { Fabricate(:queue_item_same_user, user: user) }
      before do
        set_current_user
      end
      it "deletes requested queue_item" do
        delete :destroy, id: queue_item
        expect(QueueItem.count).to eq 0
      end
      it "redirects to my_queue_path" do
        delete :destroy, id: queue_item
        expect(response).to redirect_to my_queue_path
      end
      it "rearranges list order to right order" do
        Fabricate.times(4, :queue_item_same_user, user: user)
        delete :destroy, id: 2
        expect(QueueItem.all.map(&:position)).to eq [1,2,3]
      end
    end
    it_behaves_like "require_sign_in" do
      let(:action) {
        queue_item = Fabricate(:queue_item_same_user, user: user) 
        delete :destroy, id: queue_item
      }
    end
    it "do nothing if it is not current user's queue" do
      queue_item_another_user = Fabricate(:queue_item_same_user, user: Fabricate(:user)) 
      set_current_user
      expect{
        delete :destroy, id: queue_item_another_user
      }.to change(QueueItem, :count).by(0)
    end
  end


  describe "queues#update_instant (update my_queue data)" do
    let(:user)  { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let!(:queue_target) { QueueItem.where(user: user).count + 1 }

    context "authuentication"do
      it_behaves_like "require_sign_in" do
        let(:action) {post :update_instant}
      end
      it "do nothing if queue_item's user not equal current user" do
        set_current_user
        user2 = Fabricate(:user)
        Fabricate.times(2, :queue_item_same_user, user: user2)
        post :update_instant, queue_items: {
            "1" => { position: "2" },
            "2" => { position: "1" }
          }
        expect(QueueItem.all.map(&:position)).to eq [1,2]
      end
    end 

    context "single queue" do
      before do
        set_current_user
        @review = Fabricate(:review, user: user, video: video,rating: 4) 
        @queue_item = Fabricate(:queue_item, user: user, video: video )
        post :update_instant, queue_items: { @queue_item.id.to_s => { rating: "3", position: "1" }  }
      end
      it "saves rating" do
        expect(QueueItem.first.rating).to eq 3
      end
    end 

    context "mutiple queue" do
      it "saves all list orders if all vlidation of list order pass" do
        Fabricate.times(3, :queue_item_same_user, user: user)
        set_current_user
        post :update_instant, queue_items: { 
          "1" => { position: "3" }, 
          "2" => { position: "2" }, 
          "3" => { position: "1" }
        }
        queue_items_positions = QueueItem.all.each.map(&:position)
        expect(queue_items_positions).to eq [3,2,1]
      end
      it "not saves all list order if one of queue_item's validation of list order not pass" do
        Fabricate.times(3, :queue_item_same_user, user: user)
        set_current_user
        post :update_instant, queue_items: { 
          "1" => { position: "1" }, 
          "2" => { position: "2" }, 
          "3" => { position: "1" }
        }
        queue_items_positions = QueueItem.all.each.map(&:position)
        expect(queue_items_positions).to eq [1,2,3]
      end
      it "quicklly change list order to buttom by assign it's list order to maxium of list order now + 1" do
        Fabricate.times(3, :queue_item_same_user, user: user)
        set_current_user
        post :update_instant, queue_items: { 
          "1" => { position: "4" }, 
          "2" => { position: "2" }, 
          "3" => { position: "3" }
        }
        queue_items_positions = QueueItem.all.each.map(&:position)
        expect(queue_items_positions).to eq [3,1,2]
      end
      it "changes rating" do
        review = Fabricate(:review, user: user, video: video, rating: 1) 
        Fabricate(:queue_item, user: user, video: video)
        set_current_user
        post :update_instant, queue_items: { 
          "1" => { position: "1", rating: "3" }, 
        }
        queue_items_ratings = QueueItem.all.map{ |f| f.rating }
        expect(queue_items_ratings).to eq [3]           
      end
      it "creates review when queue_item has no review and save rating to it" do
        Fabricate(:queue_item_same_user, user: user)
        set_current_user
        post :update_instant, queue_items: { 
          "1" => { position: "1", rating: "3" }, 
        }
        queue_items_ratings = QueueItem.all.map{ |f| f.rating }
        expect(queue_items_ratings).to eq [3]           
      end
      it "clears rating if reset to blank" do
        set_current_user
        review = Fabricate(:review, user: user, video: video, rating: 1) 
        Fabricate(:queue_item, user: user, video: video)
        post :update_instant, queue_items: { 
          "1" => { position: "1", rating: "" }, 
        }
        queue_items_ratings = QueueItem.all.map{ |f| f.rating }
        expect(queue_items_ratings).to eq [nil]           
        #view option parameter is nil but pass tp params is "" ;However, passing "" here resulting rating value nil??!!
      end
    end
  end
end




