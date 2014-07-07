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
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: "usd",
          card: options[:card]
        )
        new(response, :success)
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
        new(response, :success)
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

  def self.set_api_key
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end
end
