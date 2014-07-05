require 'spec_helper'

describe StripeWrapper do
  let(:valid_stripe_token) do
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
    Stripe::Token.create(
      card: {
        number: "4242424242424242",
        exp_month: 6,
        exp_year: 2015,
        cvc: "314"
      }
    ).id
  end

  let(:card_declined_stripe_token) do
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
    Stripe::Token.create(
      card: {
        number: "4000000000000002",
        exp_month: 6,
        exp_year: 2015,
        cvc: "314"
      }
    ).id
  end

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
