shared_examples "require_sign_in" do
  it "redirects to root_path" do
    clear_current_user
    action if !!defined?(action)
    expect(response).to redirect_to root_path
  end
end
shared_examples "require_admin" do
  it "redirects to root_path" do
    user if !!defined?(user)
    set_current_user
    action if !!defined?(action)
    expect(response).to redirect_to root_path
  end
end
shared_examples "require_same_user" do
  it "redirects to root_path" do
    user if !!defined?(user)
    set_current_user
    action if !!defined?(action)
    expect(response).to redirect_to root_path
    expect(flash[:danger]).to eq  "You must be the same user to do that"
  end
end
