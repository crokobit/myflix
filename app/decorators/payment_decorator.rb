class PaymentDecorator < Draper::Decorator
  delegate_all

  def next_billing_date
    Time.at(object.end_time).strftime("%d/%m/%Y")
  end

  def created_date
    Time.at(object.start_time).strftime("%d/%m/%Y")
  end
  
  def duration
    "#{Time.at(object.start_time).strftime("%d/%m/%Y")} ~ #{Time.at(object.end_time).strftime("%d/%m/%Y")}" 
  end

  def show_amount
    "$#{object.amount}" 
  end
end
