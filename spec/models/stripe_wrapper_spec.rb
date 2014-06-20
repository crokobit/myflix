require 'spec_helper'

describe StripeWrapper do
  describe "charge with valid card" do
    before do
      Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
      token = Stripe::Token.create(
        card: {
          number: "4242424242424242",
          exp_month: 6,
          exp_year: 2015,
          cvc: "314"
        }
      ).id

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

  describe "charge with invalid card" do
    before do
      Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
      token = Stripe::Token.create(
        card: {
          number: "4000000000000002",
          exp_month: 6,
          exp_year: 2015,
          cvc: "314"
        }
      ).id

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
