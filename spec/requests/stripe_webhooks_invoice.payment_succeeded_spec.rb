require 'spec_helper'

describe "invoice.payment_succeeded event" do
  let(:invoice_payment_succeeded_event_data) do
    {
      "id" => "evt_14IfSv4zdTxaHvAk6InmX49v",
      "created" => 1405944025,
      "livemode" => false,
      "type" => "invoice.payment_succeeded",
      "data" => {
        "object" => {
          "date" => 1405944025,
          "id" => "in_14IfSv4zdTxaHvAkMx3YGsE5",
          "period_start" => 1405944025,
          "period_end" => 1405944025,
          "lines" => {
            "object" => "list",
            "total_count" => 1,
            "has_more" => false,
            "url" => "/v1/invoices/in_14IfSv4zdTxaHvAkMx3YGsE5/lines",
            "data" => [
              {
                "id" => "sub_4RYaIXR0qKYWEc",
                "object" => "line_item",
                "type" => "subscription",
                "livemode" => false,
                "amount" => 2000,
                "currency" => "usd",
                "proration" => false,
                "period" => {
                  "start" => 1405944025,
                  "end" => 1408622425
                },
                "quantity" => 1,
                "plan" => {
                  "interval" => "month",
                  "name" => "Amazing Gold Plan",
                  "created" => 1404571232,
                  "amount" => 2000,
                  "currency" => "usd",
                  "id" => "gold",
                  "object" => "plan",
                  "livemode" => false,
                  "interval_count" => 1,
                  "trial_period_days" => nil,
                  "metadata" => {},
                  "statement_description" => nil
                },
                "description" => nil,
                "metadata" => {}
              }
            ]
          },
          "subtotal" => 2000,
          "total" => 2000,
          "customer" => "cus_4RYalEj74BTkoc",
          "object" => "invoice",
          "attempted" => true,
          "closed" => true,
          "forgiven" => false,
          "paid" => true,
          "livemode" => false,
          "attempt_count" => 1,
          "amount_due" => 2000,
          "currency" => "usd",
          "starting_balance" => 0,
          "ending_balance" => 0,
          "next_payment_attempt" => nil,
          "webhooks_delivered_at" => nil,
          "charge" => "ch_14IfSv4zdTxaHvAkH1ue8la5",
          "discount" => nil,
          "application_fee" => nil,
          "subscription" => "sub_4RYaIXR0qKYWEc",
          "metadata" => {},
          "statement_description" => nil,
          "description" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 2,
      "request" => "iar_4RYa5sc3j1Zx4M"
    }
  end
  before do
    @payment = Payment.create(reference_id: "ch_14IfSv4zdTxaHvAkH1ue8la5", customer_id: "cus_4RYalEj74BTkoc", amount: "2000")
  end
  it "saves period duration data to Payment", :vcr  do
    post '/stripe', invoice_payment_succeeded_event_data
    expect(Payment.first.start_time).to eq 1405944025
    expect(Payment.first.end_time).to eq 1408622425
    expect(Payment.first.cancel_at_period_end).to be_false
  end
end
