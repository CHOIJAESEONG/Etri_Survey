class FirstController < ApplicationController
  # for InvalidAuthenticityToken
  skip_before_filter :verify_authenticity_token
  
  # 설문 페이지
  def get_page
    if session[:user_id] != nil
      @user = User.find(session[:user_id])
      unless Filtering.exists? @user.sUserID
        redirect_to "/filtering" 
      end
      
      # 마지막 샷이라면
      @lastShot = ShotInfo.last
      if @user.currentShot >= @lastShot.id
        redirect_to "/contact" 
      end
          
      @first_survey = FirstSurvey.new
    else
      redirect_to "/login"
    end 
  end
  
  # 정보 요청할 떄
  def get_json
    get_information
    
    request.format = :json
    respond_to do |format|
    format.json { render :json => [shotIDList: @shotIDList, startTimeList: @startTimeList, endTimeList: @endTimeList, videoURL: @videoURL, CID: @CID, title: @title, totalShot: (@user.currentShot * 100.0 / (@lastShot.id + 1))] }
    end
  end
  
  # 설문 결과 저장하고 정보 전송
  def survey_commit
    # 아이디 가져오고
    @user = User.find(session[:user_id])
    
    # form 데이터 받아오고 아이디 추가
    @first = FirstSurvey.new
    @data = JSON.parse(params[:survey])
    @first.cID = @data["cID"]
    @first.shotID = @data["shotID"]
    @first.fileName = @data["fileName"]
    @first.preference = @data["preference"]
    @first.reason = @data["reason"]
    @first.timestamp = Time.now
    @first.sUserID = @user.sUserID
       
    if @first.save # 데이터베이스에 잘 저장 되었다면
      # currentShot 증가
      @user.currentShot += @user.group
      if @user.save # 데이터베이스에 잘 저장 되었다면
        @lastShot = ShotInfo.last
        
        if @user.currentShot > @lastShot.id
          @isLast = true
          
          request.format = :json
          respond_to do |format|
            format.json { render :json => [shotIDList: "", startTimeList: "", endTimeList: "", videoURL: "", CID: "", title: "", totalShot: "", isLast: @isLast] }
          end
          
        else
          @isLast = false
            
          # 정보 전송
          get_information
                  
          request.format = :json
          respond_to do |format|
            format.json { render :json => [shotIDList: @shotIDList, startTimeList: @startTimeList, endTimeList: @endTimeList, videoURL: @videoURL, CID: @CID, title: @title, totalShot: (@user.currentShot * 100.0 / (@lastShot.id + 1)), isLast: @isLast] }
          end
        end
      else # user 저장 실패
        render 'get_json'
      end
      
    else # first_survey 저장 실패
      render 'get_json'
    end
  end
  
  # ADMIN
  # 1차 설문 리스트 보기
  def index
    @first_surveys = FirstSurvey.all
  end

  # 1차 설문 수정
  def edit
    @first_survey = FirstSurvey.find(params[:id])
  end

  def update
    @first_survey = FirstSurvey.find(params[:id])
    
    respond_to do |format|
      if @first_survey.update(first_params)
        format.html { redirect_to "/admin/first", notice: "#{@first_survey.sUserID}의 ID = #{@first_survey.id} 1차 설문이 정상적으로 수정되었습니다." }
      else
        format.html { render :edit }
      end
    end
  end

  # 1차 설문 삭제
  def destroy
    @first_survey = FirstSurvey.find(params[:id])
    @sUserID = @first_survey.sUserID
    @first_survey.destroy
    respond_to do |format|
      format.html { redirect_to "/admin/first", notice: "#{@sUserID}의 ID = #{params[:id]} 1차 설문이 정상적으로 삭제되었습니다." }
    end
  end
  
  private
    # currentShot으로 샷을 셀렉트함. 특정 샷이 없을 경우 nil 반환
    def get_shot
      begin
        # id로 찾음
        shot = ShotInfo.find(@user.currentShot)
        return shot
      rescue ActiveRecord::RecordNotFound => e
        return nil
      end
    end
    
    # 샷 리스트, 시작시간, 끝 시간, 동영상 URL, CID, 동영상 제목 등 정보를 가져와 변수에 할당하는 함수
    def get_information
      @user = User.find(session[:user_id])
      @lastShot = ShotInfo.last
      
      # currentShot 가져오기
      @shot = get_shot
      while @shot == nil
        @user.currentShot += 1
        @shot = get_shot
      end
      
      if @user.save
        # video 가져오기
        @video = Clist.find(@shot.CID)
              
        # shot List 가져오기
        @shotList = ShotInfo.where("CID = #{@video.CID} AND id >= #{@user.currentShot}")
             
        # 그룹별로 해당 샷이 다르기 때문에 설문 대상 샷 번호, 시작시간, 끝시간 리스트를 만들어 줌
        @shotIDList = Array.new
        @startTimeList = Array.new
        @endTimeList = Array.new
        @shotList.each do |shot|
          @shotIDList.push shot.ShotID
          @startTime = shot.StartFrame.split(":")
          @startTimeList.push ((@startTime[0].to_i * 3600) + (@startTime[1].to_i * 60) + (@startTime[2].to_i))
          @endTime = shot.EndFrame.split(":")
          @endTimeList.push ((@endTime[0].to_i * 3600) + (@endTime[1].to_i * 60) + (@endTime[2].to_i))
        end
              
        # 동영상 스테틱 URL 미완.
        @videoURL = @video.VideoURL.split("/").last
           
        # CID, 동영상 제목
        @CID = @video.CID
        @title = @video.ProgramName
      else
        render 'get_page'
      end
    end
    
    # 1차 설문 form 파라미터들
    def first_params
      params.require(:first_survey).permit(:preference, :reason)
    end
end