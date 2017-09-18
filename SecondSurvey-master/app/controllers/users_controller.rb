class UsersController < ApplicationController
  # 회원가입 버튼 클릭 시 GET
  def new
    # 로그인한 유저는 회원가입을 할 수 없기 때문에
    if logged_in? # 이미 로그인 했다면
      @user = User.find(session[:user_id]) # SELECT * FROM users WHERE sUserID = 로그인 세션의 유저 아이디
      
      # 진행상황&문의 페이지로
      redirect_to "/contact"
      
    else # 로그인 하지 않은 경우 정상적으로 회원가입 페이지
      @user = User.new
    end
    
    # render, redirect 등 이런게 마지막에 없을 경우 자동으로 new(함수 명).html을 랜더링
  end
  
  # 회원가입 완료 시 Post
  def create
    # 아래의 user_params 함수를 호출해 HTML form 데이터의 유효성 검사를 진행하고 정상이라면  
    @user = User.new(user_params)
    
    # 처음 가입하는 유저는 currentShot는 1, querys는 0으로 초기화
    @user.currentShot = 1
    @user.querys = 0
    
    # group 구분 해야 함. 확실하지 않기 때문에 일단 1로 할당
    @user.group = 1
    
    # 전화번호의 -을 없앰
    @user.phone.gsub!('-', '')
    
    if @user.save # 데이터베이스에 잘 저장 되었다면
      log_in @user # 자동으로 로그인
      # 진행상황&문의 페이지로
      redirect_to "/contact"
    else # 데이터베이스에 저장 실패할 경우 다시 회원가입 페이지
      render 'new'
    end
  end
  
  # 회원정보 변경 시 GET
  def edit
    @user = User.find(session[:user_id])
  end
    
  # 회원정보 변경 시 POST
  def update
    @user = User.find(session[:user_id])

    if @user.update(update_params)
      render 'show'
    else
      render 'edit'
    end
  end
  
  # 비밀번호 변경 시 GET
  def password_edit
    @user = User.new
  end
    
  # 비밀번호 변경 시 POST
  def password_update
    @user = User.find(session[:user_id])

    if @user.update(password_params)
      render 'show'
    else
      render 'password_edit'
    end
  end
  
  # ADMIN
  # user 리스트 보기
  def index
    @users = User.all
  end
  
  # 관리자가 유저를 추가할 떄
  def admin_new
    @user = User.new
  end
  
  def admin_create
    @user = User.new(admin_user_params)
    
    @user.phone.gsub!('-', '')
    
    respond_to do |format|
      begin
        @user.save
        format.html { redirect_to "/admin/users", notice: "#{@user.name} 회원이 정상적으로 추가되었습니다." }
      rescue ActiveRecord::InvalidForeignKey  => e
        format.html { redirect_to "/admin/users/admin_new", notice: "회원 추가에 실패했습니다." }
      end
    end
  end
  
  # 관리자가 유저 정보를 수정할 떄
  def admin_edit
    @user = User.find(params[:sUserID])
  end
  
  def admin_update
    @user = User.find(params[:sUserID])
    
    respond_to do |format|
      if @user.update(admin_update_params)
        format.html { redirect_to "/admin/users", notice: "#{@user.name}의 정보가 정상적으로 수정되었습니다." }
      else
        format.html { render :admin_edit }
      end
    end
  end
  
  # 관리자가 유저를 삭제할 때
  def destroy
    @user = User.find(params[:sUserID])
    @name = @user.name
    @user.destroy
    respond_to do |format|
      format.html { redirect_to "/admin/users", notice: "#{@name} 회원이 정상적으로 삭제되었습니다." }
    end
  end
  
  private
    # 회원가입 시 form 파라미터들
    def user_params
      params.require(:user).permit(:sUserID, :name, :password, :password_confirmation, :birthday, :phone, :sex, :married, :children, :job, :company, :hobby)
    end
    
    # 회원정보 변경 시 form 파라미터들
    def update_params
      params[:user][:phone].gsub!('-', '')
      params.require(:user).permit(:name, :birthday, :phone, :sex, :married, :children, :job, :company, :hobby)
    end
    
    # 비밀번호 변경 시 form 파라미터들
    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    # ADMIN
    # 관리자 수정 form 파라미터들
    def admin_update_params
      params[:user][:phone].gsub!('-', '')
      params.require(:user).permit(:sUserID, :name, :birthday, :phone, :sex, :married, :children, :job, :company, :hobby, :currentShot, :querys, :group)
    end
    
    # 관리자 추가 form 파라미터들
    def admin_user_params
      params.require(:user).permit(:sUserID, :name, :password, :password_confirmation, :birthday, :phone, :sex, :married, :children, :job, :company, :hobby, :currentShot, :querys, :group)
    end
end
