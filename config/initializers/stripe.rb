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
      reference_id: charge_reference_id(event),
      customer: customer, 
      amount: charge_amount(event)
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
    if event["type"] == 'invoice.payment_succeeded'
      customer = find_customer_by_customer_token(invoice_payment_succeeded_customer_token(event))
      Event.create(event: event["type"], customer_id: customer.id)
    elsif event["type"] == 'charge.succeeded'
      customer = find_customer_by_customer_token(charge_customer_token(event))
      Event.create(event: event["type"], customer_id: customer.id)
    else
      Event.create(event: event["type"])
    end
  end

  def find_customer_by_customer_token(customer_token)
    User.find_by(customer_token: customer_token) 
  end

  def invoice_payment_succeeded_customer_token(event)
    event["data"]["object"]["customer"]
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
  def charge_reference_id(event)
    event["data"]["object"]["id"]
  end
  def charge_amount(event)
    event["data"]["object"]["amount"]
  end
end
