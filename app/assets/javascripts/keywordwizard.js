
$(document).ready(function(){
/* Functions for the secondary wizard */
$(".keyword_next").click(function(e){
		
		var page=$(this).data('page');
		var a= actions[page](this);
		if(a)
		{
			$(this).parent().hide();
			a.show();
			a.children().show();
			e.preventDefault();
			return false;
		}
	});
	
	actions = {
		'page0': function(x)
		   {
			 FilterKeyword.keyword = $("#sellitem").val();
			 if(FilterKeyword.keyword.length>2)
			 {
			 	return $("#page1");
			 }
			 else
			 {
			 	alert("Inavlid entry");
			 	return 0;
			 }
		   },
		
		'page1': function(x)
		   {
			 if( $("#filtertype").val()==1)
			  {
				return $("#page2");
			  }
			return 0;
		   },
		   
		'page2': function(x)
		  {
			var btype = $("#bsnstype").val();
			if(btype==1)
			{
				FilterKeyword.btype = "'want to' OR 'looking for' OR suggest OR suggestions OR recommendations OR advices OR recommend OR advice OR Know buying OR buy";
				return $("#page3");
			}
			else if (btype==2)
			{
				FilterKeyword.btype = "'looking for' OR suggest OR suggestions OR recommendations OR advices recommend OR advice OR Know providing OR provider OR offering OR offers OR offer OR doing OR provide OR service";
				return $("#page3");
			}
		  },
		
		'page3': function(x)
		{
			if($("#rtinterest").is(':checked'))
			{
				FilterKeyword.RT = "-RT";
			}
			if($("#rtinterest").is(':checked'))
			{
				FilterKeyword.links = "-filter:links";
			}
			
			generateKeyword();
			$(".buttonNext").removeClass('buttonDisabled');
			$(".buttonNext").click();
		}  
		
	};
	
	var FilterKeyword = {};
	
	function generateKeyword()
	{
		keyword = FilterKeyword.btype+ ' ' + FilterKeyword.keyword + ' ' + FilterKeyword.RT + ' ' + FilterKeyword.links;
		$("#keywordfield").val(keyword);
		alert($("#keywordfield").val());
		
	}
	
});
	
$(document).ready(function(){
        // Smart Wizard        
        $('#wizard').smartWizard({onLeaveStep:leaveAStepCallback,
        	                      onShowStep:showStepCallback,
                                  onFinish:onFinishCallback});
 
      function leaveAStepCallback(obj){
        var step_num= obj.attr('rel'); // get the current step number
        return validateSteps(step_num); // return false to stay on step and true to continue navigation
      }
       
      function onFinishCallback(){
       if(validateAllSteps()){
        $('form').submit();
       }
      }
      
      function showStepCallback(obj)
      {
      	var step_num= obj.attr('rel');
      	if (step_num ==2)
      	{
      		$(".buttonNext").removeClass('buttonDisabled').addClass('buttonDisabled');
      	}
      	return true;
      }
       
      // Your Step validation logic
      function validateSteps(stepnumber){
        var isStepValid = true;
        // validate step 1
        if(stepnumber == 1){
          // Your step validation logic
          // set isStepValid = false if has errors
        }
        // ...  
        return isStepValid;   
      }
      function validateAllSteps(){
        var isStepValid = true;
        // all step validation logic    
        return isStepValid;
      }         
      
  });
	


$(document).ready(function(){


    $(function ()
    {
    	if ($('#geocoded').is(":checked"))
               {
					$('#geo-box').removeClass('hide');
					
                }
    });
  	$(function() {
		$('#geocoded').change(function (a)
		{
			if ($('#geocoded').is(":checked"))
               {
					$('#geo-box').removeClass('hide');
					
                }
            else
               {
			      
			      $('#geo-box').removeClass('hide').addClass('hide');
			   }
		});
		
		$('#auto-reply').change(function (a)
		{
			if ($('#auto-reply').is(":checked"))
               {
					$('#default-reply-block').removeClass('hide');
					
                }
            else
               {
			      
			      $('#default-reply-block').removeClass('hide').addClass('hide');
			   }
		});
		
		
		$('#geocode-button').click(function (argument){
			  //http://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&sensor=true_or_false)
			var request_url = "http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address="+encodeURIComponent($('#address').val());
			$.getJSON( request_url, function( data ) {
    		 
              
              longitude = data['results'][0]['geometry']['location']['lng'];
              lattitude = data['results'][0]['geometry']['location']['lat'];
              $('#lng').val(longitude);
              $('#lat').val(lattitude);
              formatted_address = data['results'][0]['formatted_address'];
              $('#formatted_address').html('<strong>'+formatted_address+'</strong>');
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