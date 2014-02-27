var marker;
var map;

var titles =[];



function getRestaurant(restaurant_id, restaurant_user, callback){
	
  $(function(){
        $.ajax({
        url:'/users/'+restaurant_user+'/restaurants/'+restaurant_id+'',
        type:"GET",
        dataType: 'json',
        
        async:'true',
        success:function (data) {
        	
          callback(data);

          }
        });
      });
}
function populateModal(data){


   var url=''   
    if (data[0].logo.url != "/images/fallback/default.png"){
      url = data[0].logo.url
    }

   var roles = ''  
   var cuisines = ''
   var percent = Math.round((data[3]/data[0].total_employees) * 100);
   $.each(data[1],function(){ cuisines += this.name + ' ' });
   $.each(data[2],function(){ roles += this + ' ' });

   var modalContainer = '';
   modalContainer += "<div class='col-xs-12 col-sm-5'>";
   if (data[0].repos != ''){
    var loc_array = data[0].repos.split(',')
    modalContainer +=   "<img src='http://maps.googleapis.com/maps/api/staticmap?markers="+loc_array[0]+"%2C"+loc_array[1]+"&zoom=16&size=374x300&maptype=roadmap&sensor=false' />" ;
   } else{
    modalContainer +=   "<img src='http://maps.googleapis.com/maps/api/staticmap?markers="+data[0].latitude+"%2C"+data[0].longitude+"&zoom=16&size=374x300&maptype=roadmap&sensor=false' />" ;
   }
   if (data[0].image.url) {
    modalContainer += "<div class='image-cont'>";
    modalContainer +=   "<img src='" + data[0].image.url + "'>";
    modalContainer += "</div>";
   }
   modalContainer += "</div>";
   modalContainer += "<div class='col-xs-12 col-sm-7'>";
   modalContainer += "<div class='row'>";
   modalContainer += 		"<h1>"+data[0].name+"</h1>";
   modalContainer +=  "<address class='col-sm-6'>";
   modalContainer += 		"<div>"+data[0].address+"</div>";
   modalContainer += 		"<div>"+data[0].city+', '+data[0].state+' '+data[0].zip+"</div>";
   modalContainer += 		"<div>"+data[0].phone+"</div>";
   modalContainer += 	"</address>";

   if(url != ''){
     modalContainer +=  "<div class='col-sm-6 logo-wrap'>"
     modalContainer += 		"<img src="+url+"/>";
     modalContainer +=  "</div>";
     modalContainer +=  "<div class='white-space'></div>";
   }
   modalContainer += 	"<div class='info col-xs-12'>";
   if (data[0].description) {
     modalContainer +=    "<div class='description'>";
     modalContainer +=      "<div>"+data[0].description+"</div>";
     modalContainer +=    "</div>";
   }
   if (cuisines) {
     modalContainer += 		"<div class='form-row'>";
     modalContainer += 			"<div class='form-label'>Cuisine</div>";
     modalContainer += 			"<div class='input'>"+cuisines+"</div>";
     modalContainer += 		"</div>";
   }
   if (data[0].hours) {
     modalContainer += 		"<div class='form-row'>";
     modalContainer += 			"<div class='form-label'>Hours</div>";
     modalContainer += 			"<div class='input'>"+data[0].hours+"</div>";
     modalContainer += 		"</div>";
   }
   if (data[0].total_employees) {
     modalContainer += 		"<div class='form-row'>";
     modalContainer += 			"<div class='form-label'>Number of Employees</div>";
     modalContainer += 			"<div class='input'>"+data[0].total_employees+"</div>";
     modalContainer += 		"</div>";
   }
   if (percent) {
     modalContainer += 		"<div class='form-row'>";
     modalContainer += 			"<div class='form-label'>Percent Trained</div>";
     modalContainer += 			"<div class='input'>"+percent+"%</div>";
     modalContainer += 		"</div>";
   }
   if (roles) {
     modalContainer += 		"<div class='form-row'>";
     modalContainer += 			"<div class='form-label'>Employees Trained</div>";
     modalContainer += 			"<div class='input'>"+roles+"</div>";
     modalContainer += 		"</div>";
   }
   if (data[0].email) {
     modalContainer += 		"<div class='form-row'>";
     modalContainer += 			"<div class='form-label'>Email</div>";
     modalContainer += 			"<div class='input'><a href='mailto:"+data[0].email+"'>"+data[0].email+"</a></div>";
     modalContainer += 		"</div>";
   }
   if (data[0].website) {
     modalContainer += 		"<div class='form-row'>";
     modalContainer += 			"<div class='form-label'>Website</div>";
     modalContainer += 			"<div class='input'><a href='"+data[0].website+"'>"+data[0].website+"</a></div>";
     modalContainer += 		"</div>";
   }
   if (data[0].facebook_url || data[0].twitter_url) {
     modalContainer += 		"<div class='form-row'>";
     modalContainer += 			"<div class='form-label'>Social Media Links</div>";
     modalContainer += 			"<div class='input'>";
     if (data[0].facebook_url) { 
      modalContainer +=       "<a href='"+data[0].facebook_url+"'>Facebook</a>";
    }
    if (data[0].facebook_url && data[0].twitter_url) {
      modalContainer +=       ", ";
    }
    if (data[0].twitter_url) {
      modalContainer +=       "<a href='"+data[0].twitter_url+"'>Twitter</a></div>";
    }
     modalContainer += 		"</div>";
   }
   if (data[0].allergy_eats_url) {
     modalContainer += 		"<div class='form-row'>";
     modalContainer += 			"<div class='form-label'>Allergy Eats</div>";
     modalContainer += 			"<a class='input'>"+data[0].allergy_eats_url+"</a>";
     modalContainer += 		"</div>";
   }
   modalContainer +=  "</div>";
   modalContainer += 	"</div>";
   modalContainer += "</div>";
  
	 $('.modal-body').append(modalContainer);
	 
}
 
function initialize(lat, lng) {
 	center = (typeof lat != 'number') ? new google.maps.LatLng(-34.397, 150.644) : new google.maps.LatLng(lat, lng)
 	
  	var mapOptions = {
    	zoom: 17,
    	center: center
  	};

  	map = new google.maps.Map(document.getElementById('map-canvas'),
          mapOptions);

}
function setpos(){

	var val = marker.position.toString().substr(1, marker.position.toString().length-2);
	$('#restaurant_repos').val(val);
	
}
function resetCenter(latlng){
	center = latlng;

	map.setCenter(latlng);
  if (marker) marker.setMap(null);
	marker = new google.maps.Marker({
	    map:map,
	    draggable:true,
	    animation: google.maps.Animation.DROP,
	    position: center
  	});
  setpos();
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
            if (data.results.length) {
              resetCenter(data.results[0].geometry.location)
              $(".map-wrap").addClass('active');
            } else {
              alert('Address not found');
            }
          }
        });
      });
}

function parseLoc(lat,lng){
	var center = new google.maps.LatLng(lat, lng)
	resetCenter(center);
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


 $(document).on('click', 'form .add_fields', function(event){
  
  	time = new Date().getTime();
  	regexp = new RegExp($(this).data('id'), 'g');
  	$(this).before($(this).data('fields').replace(regexp, time));
  	event.preventDefault();
  	$('.chosen-select').chosen();
  	
  	})
  $('form').on('click', '.remove_fields', function(event){
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('fieldset').hide();
    event.preventDefault();
	})

$(document).ready(function(){

	 $('.modalOpen').on('click', function(e){
    width = document.body.clientWidth;
      if (width > 700){
        e.preventDefault();
        $('#restaurantModal').modal('show');
        getRestaurant(this.classList[1], this.classList[2], function(data) { populateModal(data) })
      }
  	})
   $('#restaurantModal').on('hidden.bs.modal',function(){
    modalContainer = ''
    $('.modal-body').html('');
   })
})
