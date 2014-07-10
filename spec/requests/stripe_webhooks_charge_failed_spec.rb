require 'spec_helper'
describe "charge.failed" do
  let(:failed_event) do
    {
      "id" => "evt_14EjnC4zdTxaHvAkw5EdGL34",
      "created" => 1405007346,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_14EjnC4zdTxaHvAkFrOne6DN",
          "object" => "charge",
          "created" => 1405007346,
          "livemode" => false,
          "paid" => false,
          "amount" => 2000,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_14EjnB4zdTxaHvAk8ne66Js6",
            "object" => "card",
            "last4" => "0002",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 6,
            "exp_year" => 2015,
            "fingerprint" => "i4JcBuICOVTmSjCv",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "customer" => nil
          },
          "captured" => false,
          "refunds" => [],
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => nil,
          "invoice" => nil,
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil,
          "receipt_email" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 2,
      "request" => "iar_4NUmrHj7RwMIvz"
    }
  end
  before do
    @customer_token = failed_event["data"]["object"]["card"]["customer"]
    @customer = Fabricate(:user, customer_token: @customer_token)
    @ee = post '/stripe', failed_event
  end
  it "destroys that customer", :vcr do
    # Why this hit GET https://api.stripe.com/v1/events/evt_14EWDd4zdTxaHvAk19UMjSIi 
    expect(User.count).to eq 0
  end
  it "sends a mail to notify customer", :vcr do
    expect(ActionMailer::Base.deliveries).to_not be_empty
  end
end
