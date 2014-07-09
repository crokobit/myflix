Stripe.api_key = ENV['STRIPE_SECRET_KEY'] # Set your api key

StripeEvent.configure do |events|
  events.subscribe 'charge.failed' do |event|
    # Define subscriber behavior based on the event object
    event.class       #=> Stripe::Event
    event.type        #=> "charge.failed"
    event.data.object #=> #<Stripe::Charge:0x3fcb34c115f8>
  end

  events.subscribe 'charge.succeeded' do |event|
    customer = User.find_by(customer_token: event["data"]["object"]["card"]["customer"])
    Payment.create(reference_id: event["data"]["object"]["id"], customer: customer) 
  end
  events.all do |event|
  end
end
