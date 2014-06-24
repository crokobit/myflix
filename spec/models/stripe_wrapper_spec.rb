require 'spec_helper'

describe StripeWrapper do
  describe "charge with valid card" , :vcr do
    before do
      token = valid_stripe_token

      @charge = StripeWrapper::Charge.create(
        card: token,
        amount: 100
      )
    end
    it "charges succesfully" do
      expect(@charge.successful?).to be_true
    end
    it "set currency usd" do
      expect(@charge.response.currency).to eq "usd"
    end
  end

  describe "charge with invalid card" , :vcr do
    before do
      token = card_declined_stripe_token

      @charge = StripeWrapper::Charge.create(
        card: token,
        amount: 100
      )
    end
    it "charges succesfully" do
      expect(@charge.successful?).to be_false
    end
  end
end
