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

  events.subscribe 'invoice.payment_succeeded' do |event|
    payment = Payment.find_by(reference_id: event["data"]["object"]["charge"])
    payment.start_time = invoice_payment_succeeded_start_time(event)
    payment.end_time = invoice_payment_succeeded_end_time(event)
    payment.cancel_at_period_end = false
    payment.save
  end

  events.all do |event|
  end

  def invoice_payment_succeeded_start_time(event)
    event["data"]["object"]["lines"]["data"][0]["period"]["start"]
  end

  def invoice_payment_succeeded_end_time(event)
    event["data"]["object"]["lines"]["data"][0]["period"]["end"]
  end
end
