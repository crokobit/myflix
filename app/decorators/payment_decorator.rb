class PaymentDecorator < Draper::Decorator
  delegate_all

  def next_billing_date
    if object == nil || object.end_time == nil
      "stripe_event error"
    else
      Time.at(object.end_time).strftime("%d/%m/%Y")
    end
  end

  def created_date
    if object == nil || object.start_time == nil
      "stripe_event error"
    else
      Time.at(object.start_time).strftime("%d/%m/%Y")
    end
  end
  
  def duration
    if object == nil || object.end_time == nil || object.start_time == nil
      "stripe_event error"
    else
      "#{Time.at(object.start_time).strftime("%d/%m/%Y")} ~ #{Time.at(object.end_time).strftime("%d/%m/%Y")}" 
    end
  end

  def show_amount
    if object == nil || object.amount == nil
      "stripe_event error"
    else
      "$#{object.amount/100.0}" 
    end
  end
end
