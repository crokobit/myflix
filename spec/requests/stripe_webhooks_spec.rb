#require 'spec_helper'
#describe "charge.succeeded" do
#  let(:event_data) do
#    {
#      "id" => "evt_14DcFL4zdTxaHvAk84dw2fYx",
#      "created" => 1404740011,
#      "livemode" => false,
#      "type" => "charge.succeeded",
#      "data" => {
#        "object" => {
#          "id" => "ch_14DcFL4zdTxaHvAk4NWNj3Sh",
#          "object" => "charge",
#          "created" => 1404740011,
#          "livemode" => false,
#          "paid" => true,
#          "amount" => 2000,
#          "currency" => "usd",
#          "refunded" => false,
#          "card" => {
#            "id" => "card_14DcFJ4zdTxaHvAkBy0CBAxc",
#            "object" => "card",
#            "last4" => "4242",
#            "brand" => "Visa",
#            "funding" => "credit",
#            "exp_month" => 6,
#            "exp_year" => 2015,
#            "fingerprint" => "vxfYrqAiUxPB0Jp0",
#            "country" => "US",
#            "name" => nil,
#            "address_line1" => nil,
#            "address_line2" => nil,
#            "address_city" => nil,
#            "address_state" => nil,
#            "address_zip" => nil,
#            "address_country" => nil,
#            "cvc_check" => "pass",
#            "address_line1_check" => nil,
#            "address_zip_check" => nil,
#            "customer" => "cus_4MKvOMzilPZXIF"
#          },
#          "captured" => true,
#          "refunds" => [],
#          "balance_transaction" => "txn_14DcFL4zdTxaHvAkTL8RpyzB",
#          "failure_message" => nil,
#          "failure_code" => nil,
#          "amount_refunded" => 0,
#          "customer" => "cus_4MKvOMzilPZXIF",
#          "invoice" => "in_14DcFL4zdTxaHvAkL18j5D2E",
#          "description" => nil,
#          "dispute" => nil,
#          "metadata" => {},
#          "statement_description" => nil,
#          "receipt_email" => nil
#        }
#      },
#      "object" => "event",
#      "pending_webhooks" => 1,
#      "request" => "iar_4MKvn4mg2PI7Eb"
#    } 
#  end
#  before do
#    @customer = Fabricate(:user, customer_token: event_data["data"]["object"]["card"]["customer"])
#    post '/stripe', event_data
#  end
#  it "creates Payment object", :vcr do
#    expect(Payment.count).to eq 1
#  end
#
#  it "records succeeded reference event id to database", :vcr do
#    expect(Payment.first.reference_id).to eq event_data["data"]["object"]["id"]
#  end
#  it "associates this Payment event with customer (system user)", :vcr do
#    expect(Payment.first.customer).to_not be_nil
#    expect(Payment.first.customer).to eq @customer
#  end
#end

