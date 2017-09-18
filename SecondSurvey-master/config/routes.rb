Rails.application.routes.draw do
  root :to => 'sessions#new'
  
  # 진행상황 & 문의사항 페이지
  get	 '/contact',						            	 to: 'home#contact'
  
  # 관리자 페이지
  get	 '/admin',							             	 to: 'home#admin'
  
  # 유저 관리
  get	 '/admin/users',				          		 to: 'users#index'
  get	 '/admin/users/admin_new',    				 to: 'users#admin_new'
  post '/admin/users/admin_new',	     			 to: 'users#admin_create'
  get	 '/admin/users/edit:sUserID',   		 	 to: 'users#admin_edit'
  post '/admin/users/edit:sUserID',   			 to: 'users#admin_update'
  get	 '/admin/users/delete', 	       			 to: 'users#destroy'
  
  # 필터링 관리
  get	 '/admin/filterings',				         	 to: 'filterings#index'
  get	 '/admin/filterings/admin_new', 			 to: 'filterings#admin_new'
  post '/admin/filterings/admin_new',     	 to: 'filterings#admin_create'
  get	 '/admin/filterings/edit:sUserID',	 	 to: 'filterings#edit'
  post '/admin/filterings/edit:sUserID',		 to: 'filterings#update'
  get	 '/admin/filterings/delete', 		     	 to: 'filterings#destroy'
  
  # 1차 설문조사 관리
  get  '/admin/first',                       to: 'first#index'
  get  '/admin/first/edit:id',               to: 'first#edit'
  post '/admin/first/edit:id',               to: 'first#update'
  get  '/admin/first/delete',                to: 'first#destroy'
  
  # 2차 설문조사 관리
  # 쿼리 개수 설정
  get  '/admin/max',                         to: 'home#max'
  post '/admin/max',                         to: 'home#max_update'
  # 1차 쿼리
  get  '/admin/first_query',                 to: 'second#first_index'
  get  '/admin/first_query/delete',          to: 'second#first_destroy'
  get  '/admin/first_query_tag',             to: 'second#first_tag_index'
  get  '/admin/first_query_survey',          to: 'second#first_query_survey_index'
  get  '/admin/first_query_survey/edit',     to: 'second#first_query_survey_edit'
  post '/admin/first_query_survey/edit',     to: 'second#first_query_survey_update'
  # 2차 쿼리
  get  '/admin/second_query',                to: 'second#second_index'
  get  '/admin/second_query/delete',         to: 'second#second_destroy'
  get  '/admin/second_query_tag',            to: 'second#second_tag_index'
  get  '/admin/second_query_survey',         to: 'second#second_query_survey_index'
  get  '/admin/second_query_survey/edit',    to: 'second#second_query_survey_edit'
  post '/admin/second_query_survey/edit',    to: 'second#second_query_survey_update'
  
  #--------------------------------------------------------------------------
  # 회원가입, 정보 수정(비밀번호 포함), 로그인-아웃, 필터링 정보 수집 
  get	 '/signup',					            			 to: 'users#new'
  post '/signup',				             				 to: 'users#create'
  get	 '/users/edit',		           					 to: 'users#edit'
  post '/users/edit',			          				 to: 'users#update'
  get	 '/users/password',		         				 to: 'users#password_edit'
  post '/users/password',		         				 to: 'users#password_update'
  get  '/login', 					            			 to: 'sessions#new'
  post '/login',			               				 to: 'sessions#create'
  get	 '/logout',				             				 to: 'sessions#destroy'
  get	 '/filtering',		          					 to: 'filterings#new'
  post '/filtering',		          					 to: 'filterings#create'
  
  # 1차 설문
  get	 '/first',				            				 to: 'first#get_page'
  get	 '/get_first_infomation',     				 to: 'first#get_json'
  post '/get_first_infomation',	      			 to: 'first#survey_commit'
  
  # 2차 설문
  get  '/second',                            to: 'second#get_page'
  get  '/get_second_infomation_first',       to: 'second#get_first_json'
  post '/get_second_infomation_first',       to: 'second#first_commit'
  get  '/get_second_infomation_second',      to: 'second#get_second_json'
  post '/get_second_infomation_second',      to: 'second#second_commit'
end