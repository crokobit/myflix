require 'spec_helper'

feature "only admin can view paynents" do
  background do
    ivan = Fabricate(:user)
    @payment = Fabricate(:payment, customer: ivan)
  end
  scenario "admin user can view payments" do
    admin = Fabricate(:user, admin: true)  
    sign_in(admin)
    visit '/admin/views_payments'
    expect(page).to have_content @payment.customer.name
    expect(page).to have_content @payment.reference_id
    expect(page).to have_content @payment.customer.email
    expect(page).to have_content @payment.amount
  end

  scenario "normal user can not see payment" do
    sign_in
    visit '/admin/views_payments'
    expect(page).to_not have_content @payment.customer.name
    expect(page).to_not have_content @payment.reference_id
    expect(page).to_not have_content @payment.customer.email
    expect(page).to_not have_content @payment.amount
  end
end
