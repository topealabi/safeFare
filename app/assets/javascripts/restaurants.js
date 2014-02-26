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
   modalContainer += "<div class='col-xs-12 col-sm-7 right'>";
   modalContainer += 	"<div class='left'>";
   modalContainer += 		"<h2 class='orange-header'>"+data[0].name+"</h2>";
   modalContainer += 		"<p>"+data[0].address+"</p>";
   modalContainer += 		"<p>"+data[0].city+', '+data[0].state+' '+data[0].zip+"</p>";
   modalContainer += 		"<p>"+data[0].phone+"</p>";
   modalContainer += 	"</div>";

   modalContainer += 	"<div class='right'>"
   if(url != ''){
     modalContainer += 		"<img class='' style='margin-top:10px;' src="+url+"/>";
   }
   modalContainer += 	"</div>";
   modalContainer += 	"<div style='clear:both'></div>";
   modalContainer += 	"<div class='info'>";
   modalContainer += 		"<div class='col-xs-12 form-row'>";
   modalContainer += 			"<p class='form-label'>Cuisine</p>";
   modalContainer += 			"<div class='input'>"+cuisines+"</div>";
   modalContainer += 		"</div>";
   modalContainer += 		"<div class='col-xs-12 form-row'>";
   modalContainer += 			"<p class='form-label'>Hours</p>";
   modalContainer += 			"<div class='input'>"+data[0].hours+"</div>";
   modalContainer += 		"</div>";
   modalContainer += 		"<div class='col-xs-12 form-row'>";
   modalContainer += 			"<p class='form-label'>Number of Employees</p>";
   modalContainer += 			"<div class='input'>"+data[0].total_employees+"</div>";
   modalContainer += 		"</div>";
   modalContainer += 		"<div class='col-xs-12 form-row'>";
   modalContainer += 			"<p class='form-label'>Percent Trained</p>";
   modalContainer += 			"<div class='input'>"+percent+"%</div>";
   modalContainer += 		"</div>";
   modalContainer += 		"<div class='col-xs-12 form-row'>";
   modalContainer += 			"<p class='form-label'>Employees Trained</p>";
   modalContainer += 			"<div class='input'>"+roles+"</div>";
   modalContainer += 		"</div>";
   modalContainer += 		"<div class='col-xs-12 form-row'>";
   modalContainer += 			"<p class='form-label'>Email</p>";
   modalContainer += 			"<div class='input'>"+data[0].email+"</div>";
   modalContainer += 		"</div>";
   modalContainer += 		"<div class='col-xs-12 form-row'>";
   modalContainer += 			"<p class='form-label'>Website</p>";
   modalContainer += 			"<div class='input'>"+data[0].website+"</div>";
   modalContainer += 		"</div>";
   modalContainer += 		"<div class='col-xs-12 form-row'>";
   modalContainer += 			"<p class='form-label'>Menu</p>";
   modalContainer += 			"<a class='input'>Menu</a>";
   modalContainer += 		"</div>";
   modalContainer += 		"<div class='col-xs-12 form-row'>";
   modalContainer += 			"<p class='form-label'>Social Media Links</p>";
   modalContainer += 			"<div class='input'><a href='"+data[0].facebook_url+"'>Facebook</a>, <a href='"+data[0].twitter_url+"'>Twitter</a></div>";
   modalContainer += 		"</div>";
   modalContainer += 		"<div class='col-xs-12 form-row'>";
   modalContainer += 			"<p class='form-label'>Allergy Eats</p>";
   modalContainer += 			"<a class='input'>"+data[0].allergy_eats_url+"</a>";
   modalContainer += 		"</div>";
   modalContainer += 	"</div>";
   modalContainer += "</div>";
   modalContainer += "<div class='col-xs-12 col-sm-5 left' style='text-align:center'>";
   if (data[0].repos != ''){
    var loc_array = data[0].repos.split(',')
    modalContainer +=   "<img class='' style='max-width:100%' src='http://maps.googleapis.com/maps/api/staticmap?markers="+loc_array[0]+"%2C"+loc_array[1]+"&zoom=18&size=300x300&maptype=roadmap&sensor=false' />" ;

   }else{
    modalContainer +=   "<img class='' style='max-width:100%' src='http://maps.googleapis.com/maps/api/staticmap?markers="+data[0].latitude+"%2C"+data[0].longitude+"&zoom=18&size=300x300&maptype=roadmap&sensor=false' />" ;

   }
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
	marker = new google.maps.Marker({
	    map:map,
	    draggable:true,
	    animation: google.maps.Animation.DROP,
	    position: center
  	});
  console.log(marker);
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
              $(".map-wrap").css('height', '200');
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
