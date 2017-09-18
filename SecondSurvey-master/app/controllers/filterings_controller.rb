class FilteringsController < ApplicationController
  before_action :set_filtering, only: [:show, :edit, :update, :destroy]
  # for InvalidAuthenticityToken
  skip_before_filter :verify_authenticity_token
  
  # 유저가 필터링 등록할 때
  def new
    @filtering = Filtering.new
  end
  
  def create
    @filtering = Filtering.new(filtering_params)
    @filtering.sUserID = session[:user_id]
          
    if @filtering.save
      redirect_to "/first"
    else
      render 'new'
    end
  end  
  
  # ADMIN
  # 필터링 리스트 보기
  def index
    @filterings = Filtering.all
  end

  # 필터링 추가
  def admin_new
    @filtering = Filtering.new
  end
  
  def admin_create
    @filtering = Filtering.new(admin_add_params)
         
    respond_to do |format|
      begin
        @filtering.save
        format.html { redirect_to "/admin/filterings", notice: "#{@filtering.sUserID}의 필터링이 정상적으로 추가되었습니다." }
      rescue ActiveRecord::InvalidForeignKey  => e
        format.html { redirect_to "/admin/filterings/admin_new", notice: "존재하지 않는 아이디입니다." }
      end
    end
  end  

  # 필터링 수정
  def edit
    @filtering = Filtering.find(params[:sUserID])
  end

  def update  
    respond_to do |format|
      if @filtering.update(filtering_params)
        format.html { redirect_to "/admin/filterings", notice: "#{@filtering.sUserID}의 필터링이 정상적으로 수정되었습니다." }
      else
        format.html { render :edit }
      end
    end
  end

  # 필터링 삭제
  def destroy
    @sUserID = @filtering.sUserID
    @filtering.destroy
    respond_to do |format|
      format.html { redirect_to "/admin/filterings", notice: "#{@sUserID}의 필터링이 정상적으로 삭제되었습니다." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_filtering
      @filtering = Filtering.find(params[:sUserID])
    end

    # filtering form 파라미터들
    def filtering_params
      params.require(:filtering).permit(:serviceProvider, :degree, :price)
    end
    
    # filtering form 파라미터들
    def admin_add_params
      params.require(:filtering).permit(:sUserID, :serviceProvider, :degree, :price)
    end
end
