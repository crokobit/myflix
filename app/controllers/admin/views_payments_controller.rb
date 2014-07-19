class Admin::ViewsPaymentsController < AdminsController
  def index
    @payments = Payment.all
  end
end
