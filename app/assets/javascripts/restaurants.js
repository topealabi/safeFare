var validate_element = function(input){
	var element = $(input).attr('id');
	var value = $(input).val();

	if (element == 'restaurant_email'){
		return checkEmail(value);
	}else if (element == 'restaurant_address' || element == 'restaurant_city'){
		return checkLengthShort(value);
	} else if (element == 'restaurant_total_employees') {
		return checkLength(value);	
	}else if (element == 'restaurant_zip') {
		return checkLengthLonger(value);	
	}else {
		return true;
	}
}
var checkEmail = function(value) {
    var email = value;
    var atpos=email.indexOf("@");
	var dotpos=email.lastIndexOf(".");
	if (atpos<1 || dotpos<atpos+2 || dotpos+2>=email.length){	
 		return false;
  	}else{
  		return true;
  	}
}

var checkLengthShort = function(value) {
	var input = value;
	if (input.length > 3){
		return true;
	}else{
		return false;
	}
}
var checkLengthLonger = function(value) {
	var input = value;
	if (input.length >= 5){
		return true;
	}else{
		return false;
	}
}
var checkLength = function(value) {
	var input = value;
	if (input.length >= 1){
		return true;
	}else{
		return false;
	}
}