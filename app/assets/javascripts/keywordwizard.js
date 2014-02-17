if (!String.prototype.trim)
{
    String.prototype.trim = function()
    {
        return this.replace(/^\s+|\s+$/g,'');
    };
}

/**********************************************************/

function secondsFromTime(s)
    {
    	alert(s.trim());
    	var time = s.trim().split(':');
    	var hours = parseInt(time[0].trim());
    	alert(hours);
    	var minutes = parseInt(time[1].trim());
    	alert(minutes);
    	minutes = minutes + hours * 60;
    	seconds = minutes *60;
    	alert(''+hours+' hours and '+seconds);
    	return seconds;
    }

/**********************************************************/

$(document).ready(function() {
	/* Functions for the secondary wizard */
	$(".keyword_next").click(function(e) {

		var page = $(this).data('page');
		var a = actions[page](this);
		if (a) {
			$(this).parent().hide();
			a.show();
			a.children().show();
			e.preventDefault();
			return false;
		}
	});
	
	$(".keyword_back").click(function(e) {

		    var page = $(this).data('page');
		    var a= $('#'+page);
			$(this).parent().hide();
			a.show();
			a.children().show();
			e.preventDefault();
			return false;
		
	});

	actions = {
		'page0' : function(x) {
			FilterKeyword.keyword = $("#sellitem").val();
			if (FilterKeyword.keyword.length > 2) {
				return $("#page1");
			} else {
				$.notify('Please enter a product or service', 'error');
				$("#sellitem").focus();
				return 0;
			}
		},

		'page1' : function(x) {
			/*if ($("#filtertype").val() == 1) {
				return $("#page2");
			}*/
			
			var next =[0,
				'page2',
				0,'page5','page8','page4','page6','page7',0,0,0,
				'page4'
			][$("#filtertype").val()];
			
			if(next)
			{return $('#'+next);
			}
			alert("Not available in this version");
			return 0;
		},

		'page2' : function(x) {
			var btype = $("#bsnstype").val();
			if (btype == 1) {
				FilterKeyword.btype = '"want to" OR "looking for" OR suggest OR suggestions OR recommendations OR advices OR recommend OR advice OR Know buying OR buy';
				return $("#page3");
			} else if (btype == 2) {
				FilterKeyword.btype = '"looking for" OR suggest OR suggestions OR recommendations OR advices recommend OR advice OR Know providing OR provider OR offering OR offers OR offer OR doing OR provide OR service';
				return $("#page3");
			}
		},

		'page3' : function(x) {
			if ($("#rtinterest").is(':checked')) {
				FilterKeyword.RT = "-RT";
			}
			else
			{
				FilterKeyword.RT = null;
			}
			if ($("#linkinterest").is(':checked')) {
				FilterKeyword.links = "-filter:links";
			}
			else
			{
				FilterKeyword.links = null;
			}

			generateLead();
			$.notify('Filter created', 'info');
			$(".buttonNext").removeClass('buttonDisabled');
			$(".buttonNext").click();
		},
		'page4': function(x)
		  {
			$.notify('Filter created', 'info');
			$(".buttonNext").removeClass('buttonDisabled');
			$(".buttonNext").click();
		  },
		'page5':function(x)
		  {
		  	var business_names = $('#business_known_as').val().split( "\n" );
		  	var business_websites = $('#business_websites').val().split( /,| /);
		  	var b = business_names.concat(business_websites);
		  	var keyword=null;
		  	for (var i=0; i<b.length; i++) {
                  var str = '"'+b[i].replace( /[\n\r]+/g, '' ).replace( /[\s\n\r]+/g, ' ' ).trim()+'"';
                  if(keyword)
                  {
                  	if(str.length>2) keyword = keyword+ " OR "+str;
                  }
                  else
                  {
                  	if(str.length>2) keyword = str;
                  }
                }
              keyword = keyword + " OR @" + client_twitter_name;
		  	  $("#keywordfield").val(keyword);
		  	  alert(keyword);
		  	  $.notify('Filter created', 'info');
			  $(".buttonNext").removeClass('buttonDisabled');
			  $(".buttonNext").click();
		  },
		  
		  'page6':function(x)
		  {
		  	var business_names = $('#business_known_as2').val().split( "\n" );
		  	var business_websites = $('#business_websites2').val().split( /,| /);
		  	var b = business_names.concat(business_websites);
		  	var keyword=null;
		  	for (var i=0; i<b.length; i++) {
                  var str = '"'+b[i].replace( /[\n\r]+/g, '' ).replace( /[\s\n\r]+/g, ' ' ).trim()+'"';
                  if(keyword)
                  {
                  	if(str.length>2) keyword = keyword+ " OR "+str;
                  }
                  else
                  {
                  	if(str.length>2) keyword = str;
                  }
                }
              keyword = keyword + " OR @" + client_twitter_name + " :)";
		  	  $("#keywordfield").val(keyword);
		  	  alert(keyword);
		  	  $.notify('Filter created', 'info');
			  $(".buttonNext").removeClass('buttonDisabled');
			  $(".buttonNext").click();
		  },
		  'page7':function(x)
		  {
		  	var business_names = $('#business_known_as3').val().split( "\n" );
		  	var business_websites = $('#business_websites3').val().split( /,| / );
		  	var b = business_names.concat(business_websites);
		  	var keyword=null;
		  	for (var i=0; i<b.length; i++) {
                  var str = '"'+b[i].replace( /[\n\r]+/g, '' ).replace( /[\s\n\r]+/g, ' ' ).trim()+'"';
                  if(keyword)
                  {
                  	if(str.length>2) keyword = keyword+ " OR "+str;
                  }
                  else
                  {
                  	if(str.length>2) keyword = str;
                  }
                }
              keyword = keyword + " OR @" + client_twitter_name + " :(";
		  	  $("#keywordfield").val(keyword);
		  	  alert(keyword);
		  	  $.notify('Filter created', 'info');
			  $(".buttonNext").removeClass('buttonDisabled');
			  $(".buttonNext").click();
		  },
		  
		  'page8':function(x)
		  {
		  	var business_names = $('#business_known_as4').val().split( "\n" );
		  	var business_websites = $('#business_websites4').val().split(/,| /);
		  	var compete_screen_names = $('#compete_screen_names').val().split( /,| /);
		  	var b = business_names.concat(business_websites);
		  	var keyword=null;
		  	for (var i=0; i<b.length; i++) {
                  var str = '"'+b[i].replace( /[\n\r]+/g, '' ).replace( /[\s\n\r]+/g, ' ' ).trim()+'"';
                  if(keyword)
                  {
                  	if(str.length>2) keyword = keyword+ " OR "+str;
                  }
                  else
                  {
                  	if(str.length>2) keyword = str;
                  }
                }
              
              for (var i=0; i<compete_screen_names.length; i++) {
                  var str = compete_screen_names[i].replace( /[\n\r@]+/g, '' ).replace( /[\s\n\r@]+/g, ' ' ).trim();
                  if(keyword)
                  {
                  	if(str.length>2) keyword = keyword+ " OR @"+str;
                  }
                  else
                  {
                  	if(str.length>2) keyword = str;
                  }
                }
              
              
		  	  $("#keywordfield").val(keyword);
		  	  alert(keyword);
		  	  $.notify('Filter created', 'info');
			  $(".buttonNext").removeClass('buttonDisabled');
			  $(".buttonNext").click();
		  }
		  
	};

	var FilterKeyword = {};

	function generateLead() {
		var keyword = FilterKeyword.btype + ' ' + FilterKeyword.keyword ;
		if(FilterKeyword.RT) keyword = keyword + ' ' + FilterKeyword.RT ;
		if(FilterKeyword.links) keyword= keyword + ' ' + FilterKeyword.links;
		$("#keywordfield").val(keyword);
		alert($("#keywordfield").val());

	}

});

/**********************************************************/

$(document).ready(function() {
	// Smart Wizard
	$('#wizard').smartWizard({
		onLeaveStep : leaveAStepCallback,
		onShowStep : showStepCallback,
		onFinish : onFinishCallback
	});

	function leaveAStepCallback(obj) {
		var step_num = obj.attr('rel');
		// get the current step number
		return validateSteps(step_num);
		// return false to stay on step and true to continue navigation
	}

	function onFinishCallback() {
		if (validateAllSteps()) {
			/*var allInputs = $( ":input" );
			allInputs.each( function( index, element ){
                 alert($(element).val());
                 });
			$('form').submit();*/
			
			data = {
          	phrase: $('#keywordfield').val(),
          	geocoded: $('#geocoded').val(),
          	radius: $('#radius').val(),
          	longitude: $('#lng').val(),
          	lattitude: $('#lat').val(),
          	language: (function(){
          		      if($('#lngspecific').is(':checked'))
          		      {
          		       return $('#_language').val();
          		       }
          		       else
          		       {
          		       	return null;
          		       }
                      }),
            auto_follow: $('#auto_follow').val(),
            auto_follow_time_from: secondsFromTime($('#auto_follow_time_from').val()),
            auto_follow_time_to: secondsFromTime($('#auto_follow_time_to').val()),
            auto_follow_rate: $('#auto_follow_rate').val(),
            
            auto_retweet: $('#auto_retweet').val(),
            auto_retweet_time_from: secondsFromTime($('#auto_retweet_time_from').val()),
            auto_retweet_time_to: secondsFromTime($('#auto_retweet_time_to').val()),
            auto_retweet_rate: $('#auto_retweet_rate').val(),
            
            auto_reply: $('#auto-reply').val(),
            default_reply: $('#default_reply').val(),
            auto_reply_time_from: secondsFromTime($('#auto_reply_time_from').val()),
            auto_reply_time_to: secondsFromTime($('#auto_reply_time_to').val()),
            auto_reply_rate: $('#auto_reply_rate').val(),
            
            nickname: $('#nickname').val(),
            email_notification: $('#email_notification').val(),
            notification_frequency: $('#notification_frequency').val(),
            fetch_frequency: $('#fetch_frequency').val(),
            priority: $('#priority').val(),
            color: $('#color').val(),
            max_count: $('#max_count').val()
	        };
	        $.ajax({
               type: "POST",
                url: keywords_path,
               data: {keyword:data},
            success: function(){
            	      $.notify('Keyword created', 'success');
            	      window.location.href=keywords_path;
            	      },
           dataType: 'json'
                });
            $.notify('Creating keyword', 'info');
	        
		}
		
	}

	function showStepCallback(obj) {
		var step_num = obj.attr('rel');
		if (step_num == 2) {
			$(".buttonNext").removeClass('buttonDisabled').addClass('buttonDisabled');
		}
		return true;
	}

	// Your Step validation logic
	function validateSteps(stepnumber) {
		var isStepValid = true;
		// validate step 1
		if (stepnumber == 1) {
			// Your step validation logic
			// set isStepValid = false if has errors
		}
		// ...
		return isStepValid;
	}

	function validateAllSteps() {
		var isStepValid = true;
		// all step validation logic
		    if($("#nickname").val().trim().length == 0){
    	    $.notify('Nickname is required', 'error');
            $("#nickname").focus();
            return false;
        
           }
		return isStepValid;
	}

});

/**********************************************************/

$(document).ready(function() {
/*UI control*/
	$(function() {
		if ($('#geocoded').is(":checked")) {
			$('#geo-box').removeClass('hide');

		}
		if ($('#lngspecific').is(":checked")) {
			$('#language-box').removeClass('hide');

		}
		if ($('#auto_follow').is(":checked")) {
			$('#auto-follow-block').removeClass('hide');

		}
	   if ($('#auto_retweet').is(":checked")) {
			$('#auto-retweet-block').removeClass('hide');

		}
	   if ($('#auto-reply').is(":checked")) {
			$('#default-reply-block').removeClass('hide');

		}
		if ($('#email_notification').is(":checked")) {
			$('#email-notification-block').removeClass('hide');

		}
		
	});
	

    $('.dtpicker').each(function(index){
    	var seconds = parseInt($(this).val());
    	var minutes = seconds /60;
    	var hours   = minutes/60;
    	minutes     = minutes % 60 ;
    	$(this).val(''+hours+':'+minutes);
    	
    });


    
    $('.dtpicker').datetimepicker({
	datepicker:false,
	format:'H:i'
    });
    
    $('#color1').colorPicker();

	
	$(function() {
		$('#geocoded').change(function(a) {
			if ($('#geocoded').is(":checked")) {
				$('#geo-box').removeClass('hide');

			} else {

				$('#geo-box').removeClass('hide').addClass('hide');
			}
		});
		
		$('#lngspecific').change(function(a) {
			if ($('#lngspecific').is(":checked")) {
				$('#language-box').removeClass('hide');

			} else {

				$('#language-box').removeClass('hide').addClass('hide');
			}
		});


		$('#auto-reply').change(function(a) {
			if ($('#auto-reply').is(":checked")) {
				$('#default-reply-block').removeClass('hide');

			} else {

				$('#default-reply-block').removeClass('hide').addClass('hide');
			}
		});
		
		$('#auto_follow').change(function(a) {
			
			if ($('#auto_follow').is(":checked")) {
				$('#auto-follow-block').removeClass('hide');

			} else {

				$('#auto-follow-block').removeClass('hide').addClass('hide');
			}
		});
		
	   $('#auto_retweet').change(function(a) {
			if ($('#auto_retweet').is(":checked")) {
				$('#auto-retweet-block').removeClass('hide');

			} else {

				$('#auto-retweet-block').removeClass('hide').addClass('hide');
			}
		});
		
	   $('#email_notification').change(function(a) {
			if ($('#email_notification').is(":checked")) {
				$('#email-notification-block').removeClass('hide');

			} else {

				$('#email-notification-block').removeClass('hide').addClass('hide');
			}
		});

		$('#geocode-button').click(function(argument) {
			//http://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&sensor=true_or_false)
			var request_url = "http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=" + encodeURIComponent($('#address').val());
			$.getJSON(request_url, function(data) {

				longitude = data['results'][0]['geometry']['location']['lng'];
				lattitude = data['results'][0]['geometry']['location']['lat'];
				$('#lng').val(longitude);
				$('#lat').val(lattitude);
				formatted_address = data['results'][0]['formatted_address'];
				$('#formatted_address').html('<strong>' + formatted_address + '</strong>');
				$("#geocode-button").text('Get cordinates again');
				$('#geocode-button').removeClass('disabled');

			});

			$('#formatted_address').html('');
			$("#geocode-button").text('Fetching...');
			$('#geocode-button').removeClass('disabled').addClass('disabled');
			return false;
		});

	});
});

