module UsersHelper
  def pass_invitor
    if defined? @invite_user
      @invite_user.invitor.id
    else
      nil
    end
  end
end

