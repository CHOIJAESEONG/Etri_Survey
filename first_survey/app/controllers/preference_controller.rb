class PreferenceController < ApplicationController
  # for InvalidAuthenticityToken
  protect_from_forgery with: :exceptions

  def get_html
    if current_user.nil?
      redirect_to '/'
    else
      unless User.find(current_user.id).filtering
        redirect_to '/filtering/new'
      end

      last_preference = User.find(current_user.id).PreferenceSurveys.last
      unless last_preference.nil?
        if last_preference.shot_info_id == Shot.find_all.last.id
          redirect_to '/'
        end
      end

      @preference_survey = PreferenceSurvey.new
    end
  end

  def get_data
    json_render

    request.format = :json
    respond_to do |format|
    format.json { render :json => [shot_id_List: @shot_id_List, start_time_list: @start_time_list,
                  end_time_list: @end_time_list, media_url: @media_url, media_id: @media_id, program_name: @program_name] }
    end
  end

  def survey_save
    preference_survey = PreferenceSurvey.new
    preference_survey.user_id = current_user.id

    if preference_survey.save # 데이터베이스에 저장
      # if 마지막 샷까지 저장
      # redirect_to '/'
      # else
      # json_render
      pass
    end
  end

  private
    def get_shot current_shot_id
      begin
        return shot_info = Shot.find(current_shot_id)
      rescue  ActiveRecord::RecordNotFound => e
        return nil
      end
    end

    def json_render
      current_shot_id = last_preference = User.find(current_user.id).PreferenceSurveys.last

      # current_shot_id가 없다면 1로 초기화
      if current_shot_id.nil?
        current_shot_id = 1
      end

      current_shot = get_shot current_shot_id
      @last_shot = Shot.last

      # shot id가 빈 구간 skip
      while current_shot == nil
        current_shot_id += 1
        current_shot = get_shot current_shot_id
      end

      media = Media.find(current_shot.media_id)
      shot_list = Shot.where("media_id = #{media.id} AND id >= #{current_shot_id}")

      # json 렌더링을 위한 Array 생성 및 초기화
      @shot_id_List = Array.new
      @start_time_list = Array.new
      @end_time_list = Array.new
      shot_list.each do |shot|
        @shot_id_List.push shot.id
        @start_time_code = shot.start_time_code.split(':')
        @start_time_list.push ((@start_time_code[0].to_i * 3600) + (@start_time_code[1].to_i * 60) + (@start_time_code[2].to_i))
        @end_time_code = shot.end_time_code.split(':')
        @end_time_list.push ((@end_time_code[0].to_i * 3600) + (@end_time_code[1].to_i * 60) + (@end_time_code[2].to_i))
      end

      # json 렌더링을 위한 나머지 정보
      @media_url = media.local_file
      @media_id = media.id
      @program_name = media.program_name
    end
end
