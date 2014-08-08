require 'spec_helper'
describe PlanAndBillingsController  do
  let(:user) {Fabricate(:user)}
  context "cancel_subscription" do
    before do
      StripeWrapper::Customer.stub(:cancel_subscription)
    end
    it "deactive payment" do
      set_current_user
      Payment.create(customer: user, subscription_active: false) 
      get :cancel_subscription
      expect(Payment.first.subscription_active).to be false
    end
    it_behaves_like "require_sign_in" do
      let(:action) { get :cancel_subscription }
    end
    # need login and require user
  end

  context "reactive_subscription" do
    before do
      StripeWrapper::Customer.stub(:reactive_subscription)
    end
    it "deactive payment" do
      set_current_user
      Payment.create(customer: user, subscription_active: false) 
      get :reactive_subscription
      expect(Payment.first.subscription_active).to be true
    end
    it_behaves_like "require_sign_in" do
      let(:action) { get :reactive_subscription }
    end
  end
  context "show plan and billing" do
    before do
      payment = Payment.create(
        customer_id: user.id,
        start_time: ( DateTime.now + 1.month ).to_time,
        end_time: DateTime.now.to_time
      ) 
    end
    it "selects last create payment, assigns it to @payment_undecorate" do

    end
  end
end
