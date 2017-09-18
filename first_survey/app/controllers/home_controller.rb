class HomeController < ApplicationController
  # devise login
  helper_method :resource_name, :resource, :devise_mapping, :resource_class
  def resource_name
    :user
  end
  def resource
    @resource ||= User.new
  end
  def resource_class
    User
  end
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  # home controller
  def index
    if current_user
      @user = User.find(current_user.id)
      if @user.email.nil? || @user.name.nil?
        if @user.email.nil?
          render 'finish_signup_non_email'
        else
          render 'finish_signup'
        end

      else
        unless @user.filtering
          redirect_to '/filtering/new'
        end
      end
    end
  end

  def finish_signup
    @user = User.find(current_user.id)
  end

  def finish_signup_non_email
    @user = User.find(current_user.id)
  end

  def finish_signup_commit
    @user = User.find(current_user.id)

    if params[:user].key?(:email)
      if @user.update(non_email_update_params)
        unless @user.filtering
          redirect_to '/filtering/new'
        else
          render 'index'
        end
      else
        render 'finish_signup_non_email'
      end

    else
      if @user.update(update_params)
        unless @user.filtering
          redirect_to '/filtering/new'
        else
          render 'index'
        end
      else
        render 'finish_signup'
      end
    end
  end

  private
    # 회원가입 완료 update 파라미터들 for 이메일이 없을 때
    def non_email_update_params
      params[:user][:phone].gsub!('-', '')
      params.require(:user).permit(:email, :name, :birthday, :sex, :married, :children, :job, :hobby, :phone, :company)
    end

    # 회원가입 완료 update 파라미터들
    def update_params
      params[:user][:phone].gsub!('-', '')
      params.require(:user).permit(:name, :birthday, :sex, :married, :children, :job, :hobby, :phone, :company)
    end
end
