module UsersHelper

  def roles_for_select
    User.roles - [User.role(:guest), User.role(:root)]
  end

end
