class SessionsController < ApplicationController
  def new
    # 로그인 했으면 1차 설문으로 보냄
    if logged_in?
      # 진행상황&문의 페이지로
      redirect_to "/contact"
    end
  end
 
  def create
    user = User.find_by(sUserID: params[:session][:sUserID])
    
    if user && user.authenticate(params[:session][:password])
      log_in user
      # 진행상황&문의 페이지로
      redirect_to "/contact"
    else
      flash[:danger] = 'Invalid id/password combination' # Not quite right!
      render 'new'
    end
  end
 
  def destroy
    log_out
    redirect_to root_url
  end
end
