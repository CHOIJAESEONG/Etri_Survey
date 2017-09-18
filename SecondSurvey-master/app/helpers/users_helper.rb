module UsersHelper
  def is_false var
    var == 'F' ? true : false
  end
  
  def is_admin
    if session[:user_id]
      @user = User.find session[:user_id]
      @user.group == 0 ? true : false
    end
  end
end
