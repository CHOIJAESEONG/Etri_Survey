require 'net/http'

class SecondController < ApplicationController
  # for InvalidAuthenticityToken
  skip_before_filter :verify_authenticity_token
  
  # 설문 페이지
  def get_page
    if session[:user_id]
      @user = User.find(session[:user_id])
            
      unless Filtering.exists? @user.sUserID
        redirect_to "/filtering" 
      end
    else
      redirect_to "/login"
    end
  end
  
  #-------------------------- 1차 쿼리
  # 1차 쿼리 정보 요청할 떄
  def get_first_json
    first
    
    request.format = :json
    respond_to do |format|
    format.json { render :json => [shotIDList: @shotIDList, startTimeList: @startTimeList, endTimeList: @endTimeList, videoURLList: @videoURLList, totalScoreList: @totalScoreList, thumbList: @thumbList, queryIDList: @queryIDList] }
    end
  end
  
  # 1차 쿼리 저장하고 2차 쿼리로 넘어감
  def first_commit       
    # 유저 정보 받아오고
    if session[:user_id]
      @user = User.find(session[:user_id])
      # form 데이터 받아오고 for문
      @surveyList = JSON.parse(params[:data])
          
      for @survey in @surveyList
        @firstQuerySurvey = FirstQuerySurvey.new
        @firstQuerySurvey.queryID = @survey["queryID"]
        @firstQuerySurvey.shotID = @survey["shotID"]
        @firstQuerySurvey.totalScore = @survey["totalScore"]
        @firstQuerySurvey.correct = @survey["correct"]
        @firstQuerySurvey.preference = @survey["preference"]
        @firstQuerySurvey.reason = @survey["reason"]
        @firstQuerySurvey.isSelect = @survey["isSelect"]
            
        if @firstQuerySurvey.save # 데이터베이스에 잘 저장 되었다면
          @user.querys += 1 # query  1 증가
          if @user.save # 데이터베이스에 잘 저장 되었다면
            next
          else
            render 'get_page'                
          end
        else
          render 'get_page'
        end              
      end
    else
      redirect_to "/login"
    end
  end
  
  #-------------------------- 2차 쿼리
  # 2차 쿼리 정보 요청할 떄
  def get_second_json
    second
    
    request.format = :json
    respond_to do |format|
    format.json { render :json => [shotIDList: @shotIDList, startTimeList: @startTimeList, endTimeList: @endTimeList, videoURLList: @videoURLList, totalScoreList: @totalScoreList, thumbList: @thumbList, queryIDList: @queryIDList] }
    end
  end
  
  # 2차 쿼리 저장하고 다시 2차 설문으로 넘어감
  def second_commit
    # 유저 정보 받아오고
    if session[:user_id]
      @user = User.find(session[:user_id])
    
      # form 데이터 받아오고 for문
      @surveyList = JSON.parse(params[:data])
        
      for @survey in @surveyList
        @secondQuerySurvey = SecondQuerySurvey.new
        @secondQuerySurvey.queryID = @survey["queryID"]
        @secondQuerySurvey.shotID = @survey["shotID"]
        @secondQuerySurvey.firstQueryID = @survey["firstQueryID"]
        @secondQuerySurvey.totalScore = @survey["totalScore"]
        @secondQuerySurvey.correct = @survey["correct"]
        @secondQuerySurvey.similarity = @survey["similar"]
        @secondQuerySurvey.preference = @survey["preference"]
        @secondQuerySurvey.reason = @survey["reason"]
        @secondQuerySurvey.isSelect = @survey["isSelect"]
        
        if @secondQuerySurvey.save # 데이터베이스에 잘 저장 되었다면
          @user.querys += 1 # query  1 증가
          if @user.save # 데이터베이스에 잘 저장 되었다면
            next
          else
            render 'get_page'                
          end
        else
          render 'get_page'
        end              
      end
    else
      redirect_to "/login"
    end
  end
  
  #------------------------ ADMIN
  #------------------------ 1차 쿼리
  # for first_quries 테이블. 삭제는 가능하나 수정은 불가능함. ETRI에서 주는 데이터가 있기 때문
  # 1차 쿼리 리스트 보기
  def first_index
    @firstQueries = FirstQuery.all
  end
  # 1차 쿼리 삭제
  def first_destroy
    @firstQuery = FirstQuery.find(params[:queryID])
    @sUserID = @firstQuery.sUserID
    @firstQuery.destroy
    respond_to do |format|
      format.html { redirect_to "/admin/first_query", notice: "#{@sUserID}의 queryID = #{params[:queryID]} 1차 쿼리가 정상적으로 삭제되었습니다." }
    end
  end
  # for first_query_tags 테이블. 삭제, 수정 모두 불가능함. 삭제하고 싶다면 1차 쿼리 리스트에서 같은 queryID를 삭제
  # 1차 쿼리 태그 리스트 보기
  def first_tag_index
    @tags = FirstQueryTag.all
  end
  # 1차 쿼리 설문 리스트 보기
  def first_query_survey_index
    @firstQuerySurveys = FirstQuerySurvey.all
  end
  def first_query_survey_edit
    @firstQuerySurvey = FirstQuerySurvey.where("queryID = #{params[:queryID]} AND shotID = #{params[:shotID]}")[0]
  end
  def first_query_survey_update
    @firstQuerySurvey = FirstQuerySurvey.where("queryID = #{params[:first_query_survey][:queryID]} AND shotID = #{params[:first_query_survey][:shotID]}")[0]
    
    respond_to do |format|
      if @firstQuerySurvey.update(first_params)
        format.html { redirect_to "/admin/first_query_survey", notice: "쿼리아이디 = #{@firstQuerySurvey.queryID}, 샷아이디 = #{@firstQuerySurvey.shotID} 설문이 정상적으로 수정되었습니다." }
      else
        format.html { render :first_query_survey_edit }
      end
    end
  end
  
  #------------------------ 2차 쿼리
  # for second_quries 테이블
  # 2차 쿼리 리스트 보기. 삭제는 가능하나 수정은 불가능함. ETRI에서 주는 데이터가 있기 때문
  def second_index
    @secondQueries = SecondQuery.all
  end
  # 2차 쿼리 삭제
  def second_destroy
    @secondQuery = SecondQuery.find(params[:queryID])
    @sUserID = @secondQuery.sUserID
    @secondQuery.destroy
    respond_to do |format|
      format.html { redirect_to "/admin/second_query", notice: "#{@sUserID}의 queryID = #{params[:queryID]} 2차 쿼리가 정상적으로 삭제되었습니다." }
    end
  end
  # for second_query_tags 테이블. 삭제, 수정 모두 불가능함. 삭제하고 싶다면 1차 쿼리 리스트에서 같은 queryID를 삭제
  # 1차 쿼리 태그 리스트 보기
  def second_tag_index
    @tags = SecondQueryTag.all
  end
  def second_query_survey_index
    @secondQuerySurveys = SecondQuerySurvey.all
  end
  def second_query_survey_edit
    @secondQuerySurvey = SecondQuerySurvey.where("queryID = #{params[:queryID]} AND shotID = #{params[:shotID]}")[0]
  end
  def second_query_survey_update
    @secondQuerySurvey = SecondQuerySurvey.where("queryID = #{params[:second_query_survey][:queryID]} AND shotID = #{params[:second_query_survey][:shotID]}")[0]
        
    respond_to do |format|
      if @secondQuerySurvey.update(second_params)
        format.html { redirect_to "/admin/second_query_survey", notice: "쿼리아이디 = #{@secondQuerySurvey.queryID}, 샷아이디 = #{@secondQuerySurvey.shotID} 설문이 정상적으로 수정되었습니다." }
      else
        format.html { render :second_query_survey_edit }
      end
    end
  end

  
  private
    # 1차 쿼리
    def first
      # First_Queries 데이터 추가
      @firstQuery = FirstQuery.new
      @firstQuery.sUserID = session[:user_id]
      @query = JSON.parse request.GET[:data]
      # "type" => "json" 제거
      @query.delete("type")
      # value가 ""(공백)인 값 제거
      @query = @query.reject { |key, value| value.empty? }
      @firstQuery.query = @query 
        
      if @firstQuery.save # 데이터베이스에 잘 저장 되었다면
        # response 만들기
        get_query_data
        
        @queryIDList = Array.new
        @queryIDList.push @firstQuery.queryID
        @queryIDList.push @firstQuery.queryID
        
        # for문 돌려야 함.
        @firstQueryTag = FirstQueryTag.new
        @firstQueryTag.queryID = @firstQuery.queryID
        # 쿼리 받으면 수정 필요
        @firstQueryTag.shotID = 1362
        @firstQueryTag.tagDesc = "고양이"
        @firstQueryTag.tagID = 2
        @firstQueryTag.tagScore = 2
        unless @firstQueryTag.save # 데이터베이스에 저장 실패할 경우 다시 1차 쿼리 페이지
          render 'get_page'
        end
      else # 데이터베이스에 저장 실패할 경우 다시 1차 쿼리 페이지
        render 'get_page'
      end
    end
    
    # 2차 쿼리
    def second
      # Second_Queries 데이터 추가
      @secondQuery = SecondQuery.new
      @secondQuery.sUserID = session[:user_id]
      request.GET.delete :type
      @secondQuery.query = request.GET
      if @secondQuery.save # 데이터베이스에 잘 저장 되었다면
        # response 만들기
        get_query_data
        
        @queryIDList = Array.new
        @queryIDList.push @secondQuery.queryID
        @queryIDList.push @secondQuery.queryID
        
        # for문 돌려야 함.
        @secondQueryTag = SecondQueryTag.new
        @secondQueryTag.queryID = @secondQuery.queryID
        # 쿼리 받으면 수정 필요
        @secondQueryTag.shotID = 1362
        @secondQueryTag.tagDesc = "고양이"
        @secondQueryTag.tagID = 2
        @secondQueryTag.tagScore = 2
        unless @secondQueryTag.save # 데이터베이스에 저장 실패할 경우 다시 1차 쿼리 페이지
          render 'get_page'
        end
      else # 데이터베이스에 저장 실패할 경우 다시 1차 쿼리 페이지
        render 'get_page'
      end
    end
    
    # 1, 2차 쿼리 http(다이스트) 통신하기!
    def get_query_data
      # request.GET 파싱 필요!!
      #url = URI.parse("http://58.72.188.33:8080/lod/search.do?" + request.GET[:data] + "&type=json")
      #req = Net::HTTP::Get.new(url.to_s)
      #@res = Net::HTTP.start(url.host, url.port) {|http|
      #  http.request(req)
      #}
      
      # response!!! 파싱 필요!!!
      # puts res.body
      # 임시 데이터
      @shotIDList = Array.new
      @shotIDList.push 1362 # 70 30
      @shotIDList.push 1378 # 77 24
      @startTimeList = Array.new
      @startTimeList.push 4.7
      @startTimeList.push 17.833333
      @endTimeList = Array.new
      @endTimeList.push 7.4666666
      @endTimeList.push 18.79166666
      @videoURLList = Array.new
      @videoURLList.push "bic_070.mp4"
      @videoURLList.push "bic_077.mp4"
      @totalScoreList = Array.new
      @totalScoreList.push 1
      @totalScoreList.push 3
      @thumbList = Array.new
      @thumbList.push "projects/Bicycle stunt/bic_077/20160109/674.jpg"
      @thumbList.push "projects/Bicycle stunt/bic_077/20160109/582.jpg"
    end
    
    # 1차 쿼리 설문 form 파라미터들
    def first_params
      params.require(:first_query_survey).permit(:queryID, :shotID, :correct, :preference, :reason, :isSelect)
    end
    
    # 2차 쿼리 설문 form 파라미터들
    def second_params
      params.require(:second_query_survey).permit(:queryID, :shotID, :correct, :similarity, :preference, :reason, :isSelect)
    end
end
