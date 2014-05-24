class InviteUser < ActiveRecord::Base
  before_save :generate_token
  belongs_to :invitor, class_name: "User", foreign_key: "invitor_id"

  def set_up_relationship
    @recipient = User.find_by(email: recipient_email)
    @recipient.followed_me_users << invitor
    @recipient.following_users << invitor
  end

  def invite_link
    new_user_via_invitation_url(self)
  end

  def to_param
    self.token
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def self.destroy_all_invitations_to(email)
    self.where(recipient_email: email).each do |obj|
      obj.destroy
    end
  end
end
