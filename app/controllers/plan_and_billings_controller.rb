class PlanAndBillingsController < ApplicationController
  before_action :require_user
  def index
    @payments = Payment.where(customer: current_user)
  end

  def cancel_subscription
    StripeWrapper::Customer.cancel_subscription(current_user)
    @payments = Payment.where(customer: current_user)
    @payments.last.subscription_active = false
    @payments.last.save
    redirect_to plan_and_billings_path
  end

  def reactive_subscription
    StripeWrapper::Customer.reactive_subscription(current_user)
    @payments = Payment.where(customer: current_user)
    @payments.last.subscription_active = true
    @payments.last.save
    redirect_to plan_and_billings_path
  end
end
