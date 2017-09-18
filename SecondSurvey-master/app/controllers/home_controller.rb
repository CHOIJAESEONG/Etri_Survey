class HomeController < ApplicationController
  def contact
    # 설문 진행 상황과 연락처를 보여준다.
    if session[:user_id] != nil
      @user = User.find(session[:user_id])
      @lastShot = ShotInfo.last
      @queries = SecondQuery.where(sUserID: @user.sUserID).length
      @max = MaxQuery.find(1)
    else
      redirect_to "/login"
    end
  end
  
  def admin
  end
  
  def max
    @max = MaxQuery.find(1)
  end
  def max_update
    @max = MaxQuery.find(1)
    
    respond_to do |format|
      if @max.update(max_params)
        format.html { redirect_to "/admin"}
      else
        format.html { render :admin_edit }
      end
    end
  end
  
  private
    def max_params
      params.require(:max_query).permit(:id, :max)
    end
end
