Stripe.api_key = ENV['STRIPE_SECRET_KEY'] # Set your api key

StripeEvent.configure do |events|
  events.subscribe 'charge.failed' do |event|
    customer = User.find_by(customer_token: event["data"]["object"]["card"]["customer"])
    AppMailer.delay.notify_customer_failed_subscription(@customer_token)
    customer.deactive!
    customer.save(validate: false)
    # need to change to deactive
  end

  events.subscribe 'charge.succeeded' do |event|
    customer = User.find_by(customer_token: event["data"]["object"]["card"]["customer"])
    Payment.create(reference_id: event["data"]["object"]["id"], customer: customer) 
  end
  events.all do |event|
  end
end
