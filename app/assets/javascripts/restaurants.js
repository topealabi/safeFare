var marker;
var map;

function initialize(lat, lng) {
 	center = (typeof lat != 'number') ? new google.maps.LatLng(-34.397, 150.644) : new google.maps.LatLng(lat, lng)
 	
  	var mapOptions = {
    	zoom: 17,
    	center: center
  	};

  	map = new google.maps.Map(document.getElementById('map-canvas'),
          mapOptions);

  	marker = new google.maps.Marker({
	    map:map,
	    draggable:true,
	    animation: google.maps.Animation.DROP,
	    position: center
  	});
  	google.maps.event.addListener(marker, 'mouseup', setpos);
}
function setpos(){

	var val = marker.position.toString().substr(1, marker.position.toString().length-2);
	$('#restaurant_repos').val(val);
	
}
function resetCenter(latlng){

	center = latlng;
	map.setCenter(latlng);
	marker = new google.maps.Marker({
	    map:map,
	    draggable:true,
	    animation: google.maps.Animation.DROP,
	    position: center
  	});
  	google.maps.event.addListener(marker, 'mouseup', setpos);
}


function geocode(params){
	$(function(){
        $.ajax({
        url:'http://maps.googleapis.com/maps/api/geocode/json?address='+params+'&sensor=true',
        type:"GET",
        dataType: 'json',
        
        async:'true',
        success:function (data) {
            resetCenter(data.results[0].geometry.location)
          }
        });
      });
}


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
$(document).ready(function(){
	$( "#check" ).click(function() {
  event.preventDefault();
  var address = $('#restaurant_address')[0];
  var city = $('#restaurant_city')[0];
  var state = $('#restaurant_state')[0];
  var params = $(address).val() + ',' + $(city).val() + ',' + $(state).val() ;
  params = params.replace(/\s+/g, '+')
  if (params.length < 5) {
  	alert('please provide a valid address');
  }else{
  	geocode(params);
	}
});

})
