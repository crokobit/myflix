Stripe.api_key = ENV['STRIPE_SECRET_KEY'] # Set your api key

StripeEvent.configure do |events|
  events.subscribe 'charge.failed' do |event|
    customer = User.find_by(customer_token: charge_customer_token(event))
    AppMailer.delay.notify_customer_failed_subscription(@customer_token)
    customer.deactive!
  end

  events.subscribe 'charge.succeeded' do |event|
    customer = User.find_by(customer_token: charge_customer_token(event)) 
    Payment.create(
      reference_id: charge_reference_id, 
      customer: customer, 
      amount: charge_amount
    ) 
  end

  events.subscribe 'invoice.payment_succeeded' do |event|
    payment = Payment.find_by(reference_id: invoice_payment_reference_id(event))

    payment.update(
      start_time: invoice_payment_succeeded_start_time(event),
      end_time: invoice_payment_succeeded_end_time(event),
      cancel_at_period_end: false,
      subscription_id: invoice_payment_succeeded_subscription_id(event),
      subscription_active: true
    )

  end

  events.all do |event|
    Event.create(event: event["type"])     
  end

  def invoice_payment_succeeded_start_time(event)
    event["data"]["object"]["lines"]["data"][0]["period"]["start"]
  end

  def invoice_payment_succeeded_end_time(event)
    event["data"]["object"]["lines"]["data"][0]["period"]["end"]
  end

  def invoice_payment_succeeded_subscription_id(event)
    event["data"]["object"]["lines"]["data"][0]["id"]
  end

  def invoice_payment_reference_id(event)
    event["data"]["object"]["charge"]
  end
  def charge_customer_token(event)
    event["data"]["object"]["card"]["customer"]
  end
  def charge_reference_id
    event["data"]["object"]["id"]
  end
  def charge_amount
    event["data"]["object"]["amount"]
  end
end
