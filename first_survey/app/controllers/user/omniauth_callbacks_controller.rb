class User::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
        else
          session["devise.#{provider}_data"] = request.env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end
  [:facebook, :kakao, :naver].each do |provider|
    provides_callback_for provider
  end

  # provider별로 회원가입 후 다른 경로 설정
  def after_sign_in_path_for(resource)
    auth = request.env['omniauth.auth']
    @identity = Identity.find_for_oauth(auth)
    @user = User.find(current_user.id)
    if @user.email.nil? || @user.name.nil?
      if @user.email.nil?
        home_finish_signup_non_email_path
      else
        home_finish_signup_path
      end
    else
      home_index_path
    end
  end
end
