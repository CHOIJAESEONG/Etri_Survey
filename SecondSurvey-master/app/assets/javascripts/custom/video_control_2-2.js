var html_body=null;
var device= null;

function Class_ProgressBar(){
	var progress=$(".progress");
	var progress_bar=$(".progress-bar");
	
	this.show_bar=function(){
		progress.show(device.animation);
	};
	this.hide_bar=function(){
		progress.hide();
	};
	this.set_bar=function(per){
		progress_bar.css('width',per);
	};
};

function Class_VideoForm(){
	
	var video_form=$("#video_form");
	
	this.show_video=function(){
		video_form.show('slide',device.animation,this.focus_video);
	};
	this.hide_video=function(){
		video_form.hide();
	};
	this.focus_video=function(){
		//html_body.animate({scrollTop : video_form.offset().top}, device.animation);
		html_body.animate({scrollTop : video_form.offset().top}, 0);
	};
	this.reset_pos=function(arg){
		video_form.after(arg);
	}
};

function Class_Modal(vid){

	var myModal=$("#myModal");
	var modal_dialog=$(".modal-dialog");
	var modal_body=$(".modal-body");
	var modal_header=$(".modal-header");
	var modal_footer=$(".modal-footer");
	var rating=$("#rateYo");//선호도
	var equal=$("#equal");//유사도
	var coincidence=$("#coincidence");//부합도
	var persent=$("#persent");
	var reason=$("textarea#id_reason");
	var open_state=false;
	var header_height=56;
	var footer_height=53;
	var video_form=vid;

	var state='5w1h_1';
	
	this.get_state=function(){return state};
	this.set_state=function(arg){state=arg};
	
	this.get_reason=function(){
		return reason.val();
	};	
	//선호도
	this.get_rating=function(){
		return rating.rateYo('rating');
	};
	var show_rating=function(){
		//rating.show();
		$('div[class="form-group  rating"]').show();
	};
	var hide_rating=function(){
		//rating.hide();
		$('div[class="form-group  rating"]').hide();
	};	
	//부합도
	this.get_coincidence=function(){
		return coincidence.rateYo('rating');
	};
	var show_coincidence=function(){
		//coincidence.show();
		$('div[class="form-group  coincidence"]').show();
	};
	var hide_coincidence=function(){
		//coincidence.hide();
		$('div[class="form-group  coincidence"]').hide();
	};	
	//유사도
	this.get_equal=function(){
		return equal.rateYo('rating');
	};
	var show_equal=function(){
		//equal.show();
		$('div[class="form-group  equal"]').show();
	};
	var hide_equal=function(){
		//equal.hide();
		$('div[class="form-group  equal"]').hide();
	};	
	
	this.set_persent=function(current){
		persent.text((current/totalShot*100).toFixed(2)+'%');
	}
	this.show_modal=function(){
		myModal.modal("show",device.animation,{backdrop: true});
	};
	this.hide_modal=function(){
		myModal.modal("hide");
	};
	this.focus_modal=function(){
		html_body.animate({scrollTop : modal_footer.offset().top}, device.animation);
	};
	var focus_modal=this.focus_modal;
	
	this.set_5w1h=function(list){
		//body.html(null);
		
		var a = document.createElement("div");
		//a.className='form-inline';
		a.setAttribute("class", 'form-group 5w1h');
		a.setAttribute("style", 'margin-right:0px; display:none;');
		
		var b = document.createElement("span");
		b.innerHTML=list.name;//+'&nbsp; &nbsp; ';
		b.setAttribute("class", 'col-xs-4 col-sm-4 col-md-2 col-lg-2');
		
		var c = document.createElement("INPUT");
		
		c.setAttribute("list", list.id);
		c.setAttribute("class", 'col-xs-8 col-sm-8 col-md-10 col-lg-10');
		c.setAttribute("placeholder", list.placeholder);
		
		var d = document.createElement("DATALIST");
		d.setAttribute("id", list.id);
		
		
		modal_body.append(a);
		a.appendChild(b);
		a.appendChild(c);
		a.appendChild(d);
		var i=0;
		for(i=0;i<list.val.length;i++){
			var e = document.createElement("OPTION");
			e.setAttribute("value", list.val[i]);
			d.appendChild(e);
		}
	};
	var set_img=function(){
		var a = document.createElement("select");
		a.setAttribute("class", 'image-picker show-html img_select');
		modal_body.append(a);
		var i=0;
		for(i=0;i<thumbList.length;i++){
			var e = document.createElement("OPTION");
			e.setAttribute("data-img-src", thumbList[i]);
			e.setAttribute("value", i);
			e.setAttribute("name", thumbList[i]);
			a.appendChild(e);
		}
		//$("select").imagepicker();
		$('.image-picker,.show-html').imagepicker({

				//initialized: function(){document.body.scrollTop = document.body.scrollHeight;},
				selected: function(selected,opt,e){
					//console.log(selected.attr('src'));
					$('#select_img').attr('src',$('.thumbnail.selected>img').attr('src'));
				},
				//click
			}
		);
		var x = document.createElement("IMG");
		x.setAttribute("class", 'img_select col-xs-12');
		x.setAttribute("id", 'select_img');
		x.setAttribute("style", 'margin-bottom:10px');
		x.onload=function(){focus_modal();};
		//x.setAttribute("style", 'height:100%');
		
		modal_body.append(x);		
		var b = document.createElement("textarea");
		b.setAttribute("class", 'img_select');
		b.setAttribute("id", 'select_reason');
		b.setAttribute("style", 'width:100%; min-height:100px;');
		b.setAttribute("placeholder", '선택한 사유를 입력해주세요');
		modal_body.append(b);
		
		$('#select_img').attr('src',$('.thumbnail.selected>img').attr('src'));

		
	}
	this.delete_img=function(){
		$('.img_select').remove();
		$('.thumbnails,image_picker_selector').remove();		
	};
	var show_5w1h=function(){
		$(".5w1h").show();
	}	
	var hide_5w1h=function(){
		//form clear
		$('.form-group.5w1h input').val('');
		$(".5w1h").hide();
	}	

	this.set_modal_bystate=function(){

		switch(state){
			case '5w1h_2':{}
			case '5w1h_1': {
					state.indexOf('5w1h_1')!=-1? $(".modal-header>h4").text('첫번째 질문 작성 (놀이공원, 요리, 생일파티, 애완동물에 관련하여 질의 부탁드립니다.)'):$(".modal-header>h4").text('두번째 질문 작성');
					state.indexOf('5w1h_1')!=-1? $("#comment").html('아래와 같은 예처럼 채워주세요.<br>\
질의에 관련된 영상이 다음 페이지에 나오면서 설문이 시작됩니다.'):$("#comment").html('첫번째 질의를 통해 최종선택하신 사진과 관련하여 아래와 같은 예처럼 채워주세요.<br>\
질의에 관련된 영상이 다음 페이지에 나오면서 설문이 시작됩니다.');
					show_5w1h();
					//선호도
					hide_rating();
					//부합도
					hide_coincidence();
					//유사도
					hide_equal();

					break;
				}
			case 'query_2':{
					$(".modal-header>h4").text('두번째 질문의 '+(count+1)+'번째 영상 (총'+start_list.length+'개)');
					hide_5w1h();
					//선호도
					show_rating();
					//부합도
					show_coincidence();
					//유사도
					show_equal();
					break;
			}
			case 'query_1': {
					$(".modal-header>h4").text('첫번째 질문의 '+(count+1)+'번째 영상 (총'+start_list.length+'개)');
					hide_5w1h();
					//선호도
					show_rating();
					//부합도
					show_coincidence();
					//유사도
					hide_equal();
					
					break;
				}
			case 'send_1':{}
			case 'send_2':{

					$(".modal-header>h4").text('질문한 내용과 가장 비슷한 영상을 선택해주세요');
					hide_rating();
					hide_coincidence();
					hide_equal();
					hide_5w1h();
					//$("#comment").html('질문한 내용과 가장 비슷한 영상을 선택해주세요').show();;
					set_img();
					break;
				}
			default: {
					break;
				}
		};
		focus_modal();
	}
	

	this.resize_modal=function(){
		var dialog_height=window.innerHeight;
		var body_height=null;
		var extra=header_height + footer_height;
		
		if(device.animation=='slow'){
			dialog_height/=2;
		}
		//body=modal-header-footer
		body_height=dialog_height - extra;
		
		modal_dialog.css('max-height',dialog_height);
		modal_body.css('max-height',body_height);
		
		
	};
	var resize_modal=this.resize_modal;
	this.isopen_modal=function(){
		return open_state;
	};

	function is_touch_device() {
		
	  return 'ontouchstart' in window        // works on most browsers 
		  || navigator.maxTouchPoints;       // works on IE10/11 and Surface
	};

	//call once
	function init(){
		
		//rating in modal
		rating.rateYo({
			rating: 3.0,//default rating
			numStars: 5,
			maxValue:5,
			//halfStar: true,
			halfStar: false,
			fullStar: true,
			//set min fill rate area
			//onInit: function (rating, rateYoInstance){	$("div[class='jq-ry-rated-group jq-ry-group']").css('min-width','10%');},
			onInit: function (rating, rateYoInstance){	$("div[class='jq-ry-rated-group jq-ry-group']").css('min-width','20%');},
			//set min value
			onSet: function (value, rateYoInstance){	if(value==0){rating.rateYo("rating", 1);}	}
		});
		equal.rateYo({
			rating: 4.0,//default rating
			numStars: 5,
			maxValue:5,
			halfStar: false,
			fullStar: true,
			//set min fill rate area
			onInit: function (rating, rateYoInstance){	$("div[class='jq-ry-rated-group jq-ry-group']").css('min-width','20%');},
			//set min value
			onSet: function (value, rateYoInstance){	if(value==0){equal.rateYo("rating", 1);}	}
		});
		coincidence.rateYo({
			rating: 5.0,//default rating
			numStars: 5,
			maxValue:5,
			halfStar: false,
			fullStar: true,
			//set min fill rate area
			onInit: function (rating, rateYoInstance){	$("div[class='jq-ry-rated-group jq-ry-group']").css('min-width','20%');},
			//set min value
			onSet: function (value, rateYoInstance){	if(value==0){coincidence.rateYo("rating", 1);}	}
		});
		//modal on/off
		//modal show/hide handler
		myModal.on('shown.bs.modal',function(e){
				//console.log(e.type);
				open_state=true;
				header_height=modal_header.outerHeight();
				footer_height=modal_footer.outerHeight();
				resize_modal();
				focus_modal();
			}
		);
		
		myModal.on('hide.bs.modal',function(e){
				//console.log(e.type);
				modal_isopen=false;
				video_form.focus_video();
				//window_resize();
			}
		);
		
		if(is_touch_device()){
			myModal.removeClass('fade');
		} else{
			//device.animation='slow';
		}
		
	};
	init();
}

function Class_SurveyForm(){
	
	var survey_form=$('#survey_form');
	
	var loading_bar=new Class_ProgressBar();
	
	var video_form=new Class_VideoForm();
	
	var myModal=new Class_Modal(video_form);
	
	var myPlayer=videojs(vid_tag_id);
	
	var firstQueryID=0;
	
	var next_btn=$("#next_btn");
	
	var survey_count=2;
	
	
	this.show_survey=function(){
		survey_form.show(device.animation);
		myModal.set_modal_bystate();
		myModal.show_modal();
		next_btn.prop('disabled',false);
		myModal.focus_modal();
	};
	var show_survey=this.show_survey;
	this.hide_survey=function(){
		survey_form.hide();
		myModal.hide_modal();
	};
	var hide_survey=this.hide_survey;
	
	myPlayer.set_curtime=function(){
		//console.log(start_list);
		myPlayer.currentTime(start_list[count]);
	};
	myPlayer.time_out=function(e){
		if(this.duration()<end_list[count]) {
			//영상의 전체길이보다 더 긴 경우 수정
			end_list[count]=this.duration();
		}

		if(this.currentTime()>=end_list[count]) {
			//console.log(this.currentTime());
			
			this.off("timeupdate",myPlayer.time_out);
		
			
			this.pause();
			show_survey();
		}		
	};
	

	

	var ajax_error=function(request,error){
		console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					
		alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	};

	
	
	function window_resize(e){
		//if(e){console.log(e.type);};
		//screen height renewal
		if(myModal.isopen_modal()){
			myModal.resize_modal();
			myModal.focus_modal();//scroll to modal	
		} else{
			//scroll to video
			video_form.focus_video();
		}		
	}
	
	function value_check(stage){
		var i=0;
		switch(stage){
			case '5w1h_2': {}
			case '5w1h_1': {
				$("input[list=Who]").val().length>0? i+=1:i+=0;
				$("input[list=WhatAction]").val().length>0? i+=1:i+=0;
				$("input[list=WhatObject]").val().length>0? i+=1:i+=0;
				$("input[list=Where]").val().length>0? i+=1:i+=0;
				$("input[list=When]").val().length>0? i+=1:i+=0;
				$("input[list=Why]").val().length>0? i+=1:i+=0;
				$("input[list=How]").val().length>0? i+=1:i+=0;
				$("input[list=Visual]").val().length>0? i+=1:i+=0;
				$("input[list=Audio]").val().length>0? i+=1:i+=0;
				
				if(i>=survey_count){
					
					if(stage=='5w1h_2'){survey_count++;}
					
					if(survey_count>=6){
						survey_count=2;
					}
					return true;
				}else{
					return false
				}
				
				break;
			}
			case 'send_2':{}
			case 'send_1':{
				i+=$("textarea#select_reason").val().length+1;
				return (i>1? true:false);
				break;
			}
			default:{i=9999;break; return (i>1? true:false);}
		}
		//console.log('stage:'+stage+' :'+i);
		return (i>1? true:false);
	}
	
	function query_5w1h_1(){
		//console.log('click'+count);
		if(value_check(myModal.get_state())==false){
			if(myModal.get_state().indexOf('5w1h')!=-1){
				alert((survey_count)+'칸을 채워주세요');
			}
			else{
				alert('빈칸을 채워주세요');
			}
			return;
		}
		next_btn.prop('disabled',true);
		
		var params=null;
		var str=null;
		
		switch(myModal.get_state()){
			case '5w1h_2': {}
			case '5w1h_1': {
					params={
						WHO:$("input[list=Who]").val(),
						WHATACTION:$("input[list=WhatAction]").val(),
						WHATOBJECT:$("input[list=WhatObject]").val(),
						WHERE:$("input[list=Where]").val(),
						WHEN:$("input[list=When]").val(),
						WHY:$("input[list=Why]").val(),
						HOW:$("input[list=How]").val(),
						VISUAL:$("input[list=Visual]").val(),
						AUDIO:$("input[list=Audio]").val(),
						type:'json'
					};
					str=JSON.stringify(params);
					break;
				}
			case 'query_1': {
					params={
						queryID:queryIDList[count],
						shotID:shot_id_list[count],
						totalScore:totalScoreList[count],
						correct:myModal.get_coincidence(),//부합도
						preference:myModal.get_rating(),//선호도
						//similar:myModal.get_equal(),//유사도
						//isSelect:(($('.image-picker,.show-html:selected').val())?true:false),
						isSelect:false,
						reason:''
					}
					surv.push(params);

					count++;
					
					if(count>=queryIDList.length){
						myModal.set_state('send_1');
						myModal.set_modal_bystate();
						next_btn.prop('disabled',false);
						return;
					}
					else{
						start();
						return;
					}	
					break;
				}
			case 'query_2': {
					params={
						queryID:queryIDList[count],
						shotID:shot_id_list[count],
						totalScore:totalScoreList[count],
						correct:myModal.get_coincidence(),//부합도
						preference:myModal.get_rating(),//선호도
						similar:myModal.get_equal(),//유사도
						firstQueryID:firstQueryID,
						//isSelect:(($('.image-picker,.show-html:selected').val())?true:false),
						isSelect:false,
						reason:''
					}
					
					surv.push(params);

					count++;
					
					if(count>=queryIDList.length){
						firstQueryID=0;
						myModal.set_state('send_2');
						myModal.set_modal_bystate();
						next_btn.prop('disabled',false);
						$(window).resize();
						return;
					}
					else{
						start();
						return;
					}	
					break;
				}
			case 'send_2' :{}
			case 'send_1' :{
					next_btn.prop('disabled',false);
					if($('.image-picker,.show-html:selected').length){
						surv[$('.image-picker,.show-html:selected').val()].isSelect=true;
						surv[$('.image-picker,.show-html:selected').val()].reason=$("textarea#select_reason").val();
						myModal.delete_img();
					}
					str=JSON.stringify(surv);
				break;
			}
			default: {
					break;
				}
		};

		//console.log(str);
		
		

		//send query info
		$.ajax({
				//type: 'GET',
				type: ((myModal.get_state().indexOf('5w1h')!=-1)?'GET':'POST'),
				//url: '/get_second_infomation_first',
				url: ((myModal.get_state().indexOf('_1')!=-1)?'/get_second_infomation_first':'/get_second_infomation_second'),
				data: {data:str},
				dataType: 'json',
				success: function(data){
						if(data!=undefined){
							//console.log('success',data[0]);
							end_list=data[0].endTimeList;
							queryIDList=data[0].queryIDList;
							shot_id_list=data[0].shotIDList;
							start_list=data[0].startTimeList;
							totalScoreList=data[0].totalScoreList;
							
							var i=0;
							for (i in data[0].videoURLList){
								data[0].videoURLList[i]='/assets/'+data[0].videoURLList[i];
							}
							video_link=data[0].videoURLList;
							
							i=0;
							for (i in data[0].thumbList){
								data[0].thumbList[i]='/assets/'+data[0].thumbList[i];
							}
							thumbList=data[0].thumbList;
							
							totalShot=data[0].totalShot;
							
														
						}
						count=0;
						surv=[];
						start();
					},
				error: ajax_error
			}
		);
		params=null;
		str=null;	
	}
	
	function file_down(url){
		loading_bar.show_bar();
		video_form.hide_video();
		var xhr = new XMLHttpRequest();
		xhr.open('GET', url, true);
		xhr.responseType = 'blob';
		////////////////////////////	
		xhr.onload = function(e) {
			if (this.status == 200) {
				//다운이 완료되면 src set
				var myBlob = this.response;
				//var vid = (window.webkitURL ? webkitURL : URL).createObjectURL(myBlob);
				var vid = (window.URL).createObjectURL(myBlob);
					myPlayer.src(vid);
					//meta data downloading
					myPlayer.on('loadedmetadata',function(e){
							//console.log(e.type);										
							this.off('loadedmetadata',arguments.callee);
							//second event
							this.on('loadeddata',function(e){
									//console.log(e.type);
									this.off('loadeddata',arguments.callee);
									myPlayer.set_curtime();
									this.on("timeupdate",myPlayer.time_out);
														
									video_form.show_video();
									this.play();	
								}
							);
						}
					);
				xhr=null;
			}
		}
		
		xhr.onprogress = function(e) {
			//다운받는동안 로딩바 갱신
			if(e.lengthComputable) {
				loading_bar.set_bar((e.loaded / e.total*100)+'%')
				if(e.loaded>=e.total) {
					loading_bar.set_bar('0%');
					loading_bar.hide_bar();
				}
			}
		}
		
		xhr.onreadystatechange= function(e) {
			//메소드 응답
			if(xhr.readyState==4) {
				//응답을 받음
				if(xhr.status==404) {
					//파일이 없을때
					//hide progress bar
					loading_bar.hide_bar();
											
					alert('video download fail please check file url or reload');
				} else if(xhr.status==200){
					//console.log("find file");
				} else {
					console.log("other error...");
					alert('server resopn: '+xhr.status);
				}
			}
		}
								
		xhr.send();
		////////////////////////////	
	}	
	
	function start(){
		
		switch(myModal.get_state()){
			case '5w1h_1':{
				firstQueryID=queryIDList[0];
				myModal.set_state('query_1');
				hide_survey();
				file_down(video_link[count]);
				break;
			}
			case 'send_1':{
				myModal.set_state('5w1h_2');
				myModal.set_modal_bystate();
				break;
			}
			case '5w1h_2':{
				myModal.set_state('query_2');
				hide_survey();
				file_down(video_link[count]);
				break;
			}
			case 'send_2':{
				myModal.set_state('5w1h_1');
				myModal.set_modal_bystate();

				break;
			}
			case 'query_1':{
			}
			case 'query_2':{
				hide_survey();
				file_down(video_link[count]);
				break;
			}
		}

	}
	function init(){
		
		console.log('survey init');

		//window resize event handler	
		$(window).on("resize",window_resize).resize();
		
		// (full screen? width:100%, xs12 lg-6)
		myPlayer.on('fullscreenchange',function(e){
			
				//move survey dom
				if(myPlayer.isFullscreen()){
					$('#video_html5_api').after(survey_form);
				} else{
					video_form.reset_pos(survey_form);
				}		
			
				//console.log(e.type);
				survey_form.toggleClass('col-lg-9');
				myModal.resize_modal();
			}
		);
		
		
		myModal.set_5w1h({id:'Who',name:'누가(사람,동물)',placeholder:'ex)선생님, 고양이 등',val:[]});
		myModal.set_5w1h({id:'WhatAction',name:'어떤행동을하다',placeholder:'ex)뛰다, 운다 등',val:[]});
		myModal.set_5w1h({id:'WhatObject',name:'어떤물체를',placeholder:'ex)빵, 가위 등',val:[]});
		myModal.set_5w1h({id:'Where',name:'어디에서',placeholder:'ex)공원, 들판 등',val:[]});
		myModal.set_5w1h({id:'When',name:'언제',placeholder:'ex)아침에, 크리스마스 등',val:[]});
		myModal.set_5w1h({id:'Why',name:'왜',placeholder:'ex)생일, 졸업식 등',val:[]})
		myModal.set_5w1h({id:'How',name:'어떻게',placeholder:'ex)배를타고, 줄을서서 등',val:[]});
		myModal.set_5w1h({id:'Visual',name:'Visual',placeholder:'시각적인 단어 ex) 고양이, 빵, 들판',val:[]});
		myModal.set_5w1h({id:'Audio',name:'Audio',placeholder:'청각적인 단어 ex) 박수, 리코더',val:[]});;
		
		//console.log(myModal.get_rating());
		//console.log(myModal.get_equal());
		//console.log(myModal.get_coincidence());
		
		
		next_btn.click(query_5w1h_1);
		myModal.set_state('5w1h_1');
	};
	
	
	init();
}


$(document).ready(function(){
	
	console.log('ready');
	html_body=$('html, body');
	device= {type:'touch',animation:0};
	survey_form=new Class_SurveyForm();
	survey_form.show_survey();
	//survey_form.myModal.show_5w1h();
	//survey_form.get_survey_info();
	console.log('end');
});
