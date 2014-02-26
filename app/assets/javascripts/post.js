var STrootform;
//the root-form

$(function(){

$(".selected-accounts").change(function() {
	var targetHolder = $("#postbox" + $(this).data('account')); //The target form holder div
	var targetForm   = $("#postbox" + $(this).data('account') + " form"); //the target form
	
	if ($(this).is(':checked')) { //does the user select the account
		if (STrootform == null) { //if there isn't any root post yet, make it the current one;
		    
			STrootform = targetForm.attr('id');
		   }
	    
	    if(STrootform == targetForm.attr('id'))
	    {
			
			targetForm.attr('data-isroot', 'true'); //mark-it as root
			targetForm.attr('data-auto', 'false');  //mark-it for no auto-fill
			//targetHolder.parent().prepend(targetHolder);  //bring-it to the top
			targetHolder.removeClass('st-faint');   //root item should be highlight, always
			$(this).attr('data-isroot','true');
			//$("label[for='" + $(this).attr('id') + "']").removeClass('st-lockbutton').addClass('st-lockbutton');//lock the button
		}
		
		targetHolder.removeClass('hide');

	} else {
		targetHolder.removeClass('hide').addClass('hide');
		
		if (STrootform == targetForm.attr('id')) {
			STrootform = null;
			
		}
		$(this).attr('data-isroot','false');
		targetForm.attr('data-isroot', 'false');
		
		targetHolder.addClass('st-faint');
		
		targetForm.attr('data-auto', 'true');
		
	}
});

$(".postholder").click(function() {

	$(this).removeClass('st-faint');
	var frm = '#' + $(this).attr('id')  +" form";
	$(frm).attr('data-auto', 'false');

});



});