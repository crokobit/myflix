module StripeWrapper
  class Charge
    attr_reader :response
    def initialize(response, status)
      @status = status
      @response = response
    end
    def self.create(options={})
     StripeWrapper.set_api_key
      begin
        @response = Stripe::Charge.create(
          amount: options[:amount],
          currency: "usd",
          card: options[:card]
        )
        new(@response, :success)
      rescue Stripe::CardError => e
        new(e.message, :error)
      end
    end
    def successful?
      @status == :success
    end
    def error_message
      @response 
    end
  end

  class Plan
    def self.create
      Stripe::Plan.create(
        amount: 2000,
        interval: 'month',
        name: 'Amazing Gold Plan',
        currency: 'usd',
        id: 'gold'  
      )
    end
  end

  class Customer
    attr_reader :response
    def initialize(response, status)
      @status = status
      @response = response
    end

    def self.create(customer, token)
      #assume already create plan by StripeWrapper::Plan.create
      begin
        response = Stripe::Customer.create(
          card: token,
          plan: "gold",
          email: customer.email
        )
        customer.customer_token = response.id
        customer.save
        new(response, :success)
      rescue Stripe::CardError => e
        new(e.message, :error)
      end
    end
    def self.cancel_subscription(customer)
      customer_response = Stripe::Customer.retrieve(customer.customer_token)
      payment = Payment.where(customer: customer).last
      customer_response.cancel_subscription(at_period_end: true)

      payment.subscription_active = false
      payment.save
    end

    def self.re_subscription(customer)
      customer_response = Stripe::Customer.retrieve(customer.customer_token)
      payment = Payment.where(customer: customer).last
      subscription_id = payment.subscription_id

      #reactive_subscription(customer_response, subscription_id)
      subscription = customer_response.subscriptions.retrieve(subscription_id)
      subscription.plan = "gold"
      subscription.save

      payment.subscription_active = true
      payment.save
    end
    def successful?
      @status == :success
    end
    def error_message
      @response 
    end
    def customer_token
      @response.id 
    end
    def reactive_subscription(customer_response, subscription_id)
    end
  end 

  def self.set_api_key
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end



end
