var html_body=null;
var device= {type:'touch',animation:0};

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
	var rating=$("#rateYo");
	var persent=$("#persent");
	var reason=$("textarea#id_reason");
	var open_state=false;
	var header_height=56;
	var footer_height=53;
	var video_form=vid;
	
	this.get_rating=function(){
		return rating.rateYo('rating');
	};
	this.get_reason=function(){
		return reason.val();
	};
	this.set_reason=function(arg){
		return reason.val(arg);
	}
	
	this.set_persent=function(current){
		//persent.text((current/totalShot*100).toFixed(2)+'%');
		persent.text((totalShot).toFixed(2)+'%');
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
		  || navigator.maxTouchPoints || true;       // works on IE10/11 and Surface
	};

	//call once
	function init(){
		
		//rating in modal
		rating.rateYo({
			rating: 3.0,//default rating
			numStars: 5,
			maxValue:5,
			halfStar: false,
			fullStar: true,
			//set min fill rate area
			onInit: function (rating, rateYoInstance){	$("div[class='jq-ry-rated-group jq-ry-group']").css('min-width','20%');},
			//set min value
			onSet: function (value, rateYoInstance){	if(value==0){rating.rateYo("rating", 1);}	}
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
			device= {type:'pc',animation:'slow'};
			//method button show
			$('#down_method').show();
			$("#down_method > div[class='form-inline'] > label").click(function(e){
					$("#method_btn").toggle();
				}
			);
		}
		
		reason.keydown(function(e){
			//console.log(e.keyCode);
			if(e.keyCode==13){
				if(e.preventDefault){
					e.preventDefault();
					var nxt_btn=next_btn=$("#next_btn");
					nxt_btn.click();					
				}else{
					var nxt_btn=next_btn=$("#next_btn");
					nxt_btn.click();
					e.returnValue = false;
				}
				
			}
		});
		
	};
	init();
}

function Class_SurveyForm(){
	
	var survey_form=$('#survey_form');
	
	var loading_bar=new Class_ProgressBar();
	
	var video_form=new Class_VideoForm();
	
	var myModal=new Class_Modal(video_form);
	
	var myPlayer=videojs(vid_tag_id);
	
	var next_btn=$("#next_btn");
	
	this.show_survey=function(){
		survey_form.show(device.animation);
		myModal.show_modal();
		next_btn.prop('disabled',false);
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
			console.log(this.currentTime());
			
			this.off("timeupdate",myPlayer.time_out);
		
			
			this.pause();
			show_survey();
		}		
	};
	
	this.get_survey_info=function(){
		//loading bar
		loading_bar.hide_bar();
		
		//survey
		hide_survey();

		//video
		video_form.hide_video();
		
		video_link=null;
		myPlayer.pause();
		
		console.log('my device',device.type);
		
		//get survey info
		$.ajax({
				type: 'GET',
				url: '/get_first_infomation',
				data: {survey: JSON.stringify('init'),},
				dataType: 'json',
				success: ajax_get_data,
				error: ajax_error
			}
		);		
	};
	var get_survye_info=this.get_survey_info;
	
	var ajax_get_data=function(data){

		
		if(video_link=='/assets/'+data[0].videoURL) {
			
			//링크가 일치하면 영상을 계속 진행
			count++;
			myPlayer.on("timeupdate",myPlayer.time_out);
			myPlayer.set_curtime();
			hide_survey();

			myPlayer.play();

		} else{
			//revoke url obj
			(window.URL).revokeObjectURL(myPlayer.currentSrc());
			
			if(data[0].isLast==true){
				//last shot
				location.replace("http://211.253.24.242/contact")
				return;
			}
			
			//처음이거나 해당 영상의 샷을 다 진행해서 다음 링크를 받은경우
			video_link='/assets/'+data[0].videoURL;
			start_list=data[0].startTimeList;
			end_list=data[0].endTimeList;
			shot_id_list=data[0].shotIDList;
			cid=data[0].CID;
			filename=data[0].title;
			totalShot=data[0].totalShot;

			hide_survey();
			//console.log('start');
			start();
		}
		myModal.set_persent(shot_id_list[count]);
		data=null;
	
	};
	var ajax_error=function(){
		console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					
		alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	};

	function start(){
		console.log('start');
		//reset count
		count=0;

		switch(device.type) {
			//바로시작    2state callback   loadedmetadata->loadeddata->play
			case 'pc' : (function pc_start(){
								console.log('pc start');
								myPlayer.src(video_link);
								//first event
								myPlayer.on('loadedmetadata',function(e){
										console.log(e.type);										
										this.off('loadedmetadata',arguments.callee);
										//second event
										this.on('loadeddata',function(e){
												console.log(e.type);
												this.off('loadeddata',arguments.callee);
												myPlayer.set_curtime();
												this.on("timeupdate",myPlayer.time_out);
												
												video_form.show_video();
												this.play();	
											}
										);
									}
								);
							}
						)();
						break;
			//다운로드 후 시작
			default :	(function(url){
								loading_bar.show_bar();
								video_form.hide_video();
								
								var xhr = new XMLHttpRequest();
								xhr.open('GET', url, true);
								xhr.responseType = 'blob';
								
								xhr.onload = function(e) {
									if (this.status == 200) {
										//다운이 완료되면 src set
										var myBlob = this.response;
										//var vid = (window.webkitURL ? webkitURL : URL).createObjectURL(myBlob);
										var vid = (window.URL).createObjectURL(myBlob);

										myPlayer.src(vid);
										//meta data downloading
										myPlayer.on('loadedmetadata',function(e){
												console.log(e.type);										
												this.off('loadedmetadata',arguments.callee);
												//second event
												this.on('loadeddata',function(e){
														console.log(e.type);
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
							}
						)(video_link);
						break;
		}		
	}
	
	function window_resize(e){
		if(e){console.log(e.type);};
		//screen height renewal
		if(myModal.isopen_modal()){
			myModal.resize_modal();
			myModal.focus_modal();//scroll to modal	
		} else{
			//scroll to video
			video_form.focus_video();
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
			
				console.log(e.type);
				survey_form.toggleClass('col-lg-6');
				myModal.resize_modal();
			}
		);
		
		next_btn.click(function(){
				if(myModal.get_reason().length==0){
					alert('사유를 입력해주세요');
					return;
				}
				console.log('click'+count);
				next_btn.prop('disabled',true);
				
				var survey = new Object();
	
				survey.cID=cid;
				survey.fileName=filename;
				survey.shotID=shot_id_list[count];
				survey.reason=myModal.get_reason();
				myModal.set_reason('');
				survey.preference= myModal.get_rating();
				//survey.time=end_list[count];
				
				$.ajax(
					{	
						type: 'POST',
						url: '/get_first_infomation',
						data: {survey: JSON.stringify(survey),},
						dataType: 'json',
						success: ajax_get_data,
						error: ajax_error
					}
				);
				//release obj
				survey=null;				
			}
		);
		$('#touch').click(function(){
			device.type='touch';
			$("#method_btn").toggle();

			myPlayer.off("timeupdate",myPlayer.time_out);
	
			get_survye_info();
		});
		$('#pc').click(function(){
			device.type='pc';
			$("#method_btn").toggle();

			myPlayer.off("timeupdate",myPlayer.time_out);
			
			get_survye_info();
		});
	};
	
	
	init();
}


$(document).ready(function(){
	
	console.log('ready');
	html_body=$('html, body');
	survey_form=new Class_SurveyForm();
	survey_form.get_survey_info();
	console.log('end');
});
