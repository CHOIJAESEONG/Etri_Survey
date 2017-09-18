


$('#user_sUserID').ready(function() {

	$('#user_sUserID').on('keyup',check_ID);
	$('#user_sUserID').on('blur',check_ID);
	$('#user_phone').on('keyup',check_Phone);
	$('#user_phone').on('blur',check_Phone);
});

function check_ID(e) {
	//console.log(this.value);
	//delete kor white space
	this.value = this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣 ]/g, '');
	
}
function check_Phone(e) {
	//delete kor eng white space
	this.value = this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣 a-z A-Z]/g, '');
}



















