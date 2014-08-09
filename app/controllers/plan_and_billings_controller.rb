class PlanAndBillingsController < ApplicationController
  before_action :require_user
  before_action :stripe_event_error_handler, only: [:index]
  def index
    payments = Payment.where(customer: current_user)
    @payment = payments.last.decorate
    @payments = payments.decorate
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

  private

  def stripe_event_error_handler
    payments = Payment.where(customer: current_user)
    if payments.blank?
      Payment.create(customer: current_user)
    end
  end
end
