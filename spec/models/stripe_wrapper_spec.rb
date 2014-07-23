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

  context "class Charge" do
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
      it "sets currency usd" do
        expect(@charge.response.currency).to eq "usd"
      end
    end

    describe "charge with declined card" , :vcr do
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
      it "has error messsage" do
        expect(@charge.error_message).to eq "Your card was declined."
      end
    end
  end

  context "Class Customer", :vcr do
    let(:customer) { Fabricate(:user) }
    it "charges customer success with valid card" do
      token = valid_stripe_token
      @customer = StripeWrapper::Customer.create(customer, token)
      expect(@customer.successful?).to be_true
    end
    it "charges customer fail with declined card" do
      token = card_declined_stripe_token
      @customer = StripeWrapper::Customer.create(customer, token)
      expect(@customer.successful?).to be_false
    end
    it "show error message when card declined" do
      token = card_declined_stripe_token
      @customer = StripeWrapper::Customer.create(customer, token)
      expect(@customer.error_message).to eq "Your card was declined."
    end
    it "returns customer_token to user with valid card" do
      token = valid_stripe_token
      @customer = StripeWrapper::Customer.create(customer, token)
      expect(User.first.customer_token).to be_present
    end
  end
end
