module StripeWrapper
  class Charge
    def initialize(response, status)
      @status = status
      @response = response
    end
    def self.create(options={})
      StripeWrapper.set_api_key
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: options[:currency],
          card: options[:card]
        )
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end
    def succeful?
      status == :success
    end
  end

  def self.set_api_key
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end
end
