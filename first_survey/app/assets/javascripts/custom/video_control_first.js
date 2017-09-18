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
var survey_form=$('#survey_form');
$(document).ready(function(){

	console.log('ready');
	html_body=$('html, body');

    survey_form.show_survey();

    myModal.set_5w1h({id:'Who',name:'누가(사람,동물)',placeholder:'ex)선생님, 고양이 등',val:[]});
    myModal.set_5w1h({id:'WhatAction',name:'어떤행동을하다',placeholder:'ex)뛰다, 운다 등',val:[]});
    myModal.set_5w1h({id:'WhatObject',name:'어떤물체를',placeholder:'ex)빵, 가위 등',val:[]});
    myModal.set_5w1h({id:'Where',name:'어디에서',placeholder:'ex)공원, 들판 등',val:[]});
    myModal.set_5w1h({id:'When',name:'언제',placeholder:'ex)아침에, 크리스마스 등',val:[]});
    myModal.set_5w1h({id:'Why',name:'왜',placeholder:'ex)생일, 졸업식 등',val:[]})
    myModal.set_5w1h({id:'How',name:'어떻게',placeholder:'ex)배를타고, 줄을서서 등',val:[]});
    myModal.set_5w1h({id:'Visual',name:'Visual',placeholder:'시각적인 단어 ex) 고양이, 빵, 들판',val:[]});
    myModal.set_5w1h({id:'Audio',name:'Audio',placeholder:'청각적인 단어 ex) 박수, 리코더',val:[]});;
});
this.show_survey=function(){
    survey_form.show(device.animation);
    myModal.set_modal_bystate();
    myModal.show_modal();
    next_btn.prop('disabled',false);
    myModal.focus_modal();
};
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
