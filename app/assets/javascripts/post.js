var STrootform=null;
//the root-form

var STPublish_post_status = 'composing';


   
  
  
  
  function postData(action)
  {
  	
  	var root_form = $("#"+STrootform);
  	var post = {
  		        content:      root_form.find($("textarea[name='post[content]']")).val(),
  				content_type: root_form.find($("input[name='post[content_type]']")).val(),
  				account_id:   root_form.find($("input[name='post[account_id]']")).val(),
  				title:        root_form.find($("input[name='post[title]']")).val(),
  				post_at:      $('#publish-post-at-datetime').val()
  	};
  	var eb_forms = $("form[data-enabled='true'][data-isroot='false']");
  	var children =[];
  	
  	
  	eb_forms.each(function(index,form)
  	{
  		form = $(form);
  		children.push(
  			{
  				content:      form.find($("textarea[name='post[content]']")).val(),
  				content_type: form.find($("input[name='post[content_type]']")).val(),
  				account_id:    form.find($("input[name='post[account_id]']")).val(),
  				title:         form.find($("input[name='post[title]']")).val()
  			}
  		);
  		
  	});
  	
  	$.ajax({
               type: "POST",
                url: STCurrent_post_publish_path,
               data: {post:post,children:children,commit:action},
            success: function(){
            	      $.notify('Posts published successfully', 'success');
            	      STPublish_post_status = 'published';
            	      clearAllPosts();
            	      },
           dataType: 'json'
                });
    $.notify('Publishing...', 'success');
  }
  
  function clearAllPosts()
  {
  	$("form textrarea").val("");
  	$("#publish-post-at-datetime").val('');
  	$("form input[type='text']").val("");
  	STPublish_post_status = 'composing';
  	$('#post-publish-button').text('Publish');
  	$('#post-save-draft-button').text('Save');
  	
  }



function createHash()
  {

  	var root_form = $("#"+STrootform);
  	var root_type = root_form.find($("input[name='post[content_type]']")).val();

  	if (root_type=='wp')
  	{   
  	 for (instance in CKEDITOR.instances){
        CKEDITOR.instances[instance].updateElement();
      }
  	}
  	var root_content = root_form.find($("textarea[name='post[content]']")).val();

  	var root_title = root_form.find($("input[name='post[title]']")).val();


  	
  	var auto_forms = $("form[data-auto='true']");
  	auto_forms.each(function(index,form){
  		form = $(form);
  		var form_type = form.find($("input[name='post[content_type]']")).val();

  		if(form_type=='wp')
  		{
  			form.find($("textarea[name='post[content]']")).val(root_content);
  			form.find($("input[name='post[title]']")).val(root_title);
  		}
  		else if(form_type=='ttr')
  		{
  			if(root_type=='wp')
  			{
  			form.find($("textarea[name='post[content]']")).val(root_title.substring(0,114)+"...\nhttp://short.url");
  			}
  			else if(root_type=='ttr')
  			{
  				form.find($("textarea[name='post[content]']")).val(root_content);
  			}
  			else
  			{
  			   form.find($("textarea[name='post[content]']")).val(root_content.substring(0,114)+"...\nhttp://short.url");
  			}
  		}
  		else if(form_type=='fb')
  		{
  			if(root_type=='wp')
  			{
  				form.find($("textarea[name='post[content]']")).val($(root_content).text().substring(0,512)+"...\nhttp://short.url");
  			}
  			else
  			{
  			form.find($("textarea[name='post[content]']")).val(root_content);
  			}
  		}
  		else
  		{
  			alert("Unknown handle");
  		}
  		
  	});

  	
  }




$(function(){

  $('#publish-post-at-datetime').datetimepicker({
		onClose : function(a) {
			$('#publish-post-at-datetime').change();
		}
	});

   $('#publish-post-at-datetime').change(function(){
   	 $(this).removeClass('st-faint');
   	
   });
   
  $('#post-publish-button').click(function()
  {
  	if(STPublish_post_status=='composing')
  	{
  		$.notify('Preparing content', 'info');
  		createHash();
  		STPublish_post_status='ready';
  		$(this).text("Submit");
  		$.notify("Please verify your posts and press 'Submit'", 'warn');
  	}
  	else if(STPublish_post_status=='ready')
  	{
  		STPublish_post_status = 'sent';
  		$(this).text("Publishing..");
  		postData('publish');
  	}
  	
  });
   
   
  $('#post-save-draft-button').click(function()
  {
  	if(STPublish_post_status=='composing')
  	{
  		$.notify('Preparing content', 'info');
  		createHash();
  		STPublish_post_status='ready';
  		$(this).text("Save now");
  		$.notify("Please verify your posts and press 'Save now'", 'warn');
  	}
  	else if(STPublish_post_status=='ready')
  	{
  		STPublish_post_status = 'sent';
  		$(this).text("Saving..");
  		postData('draft');
  	}
  	
  });






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
		targetForm.attr('data-enabled', 'true');

	} else {
		targetHolder.removeClass('hide').addClass('hide');
		
		if (STrootform == targetForm.attr('id')) {
			STrootform = null;
			
		}
		$(this).attr('data-isroot','false');
		targetForm.attr('data-isroot', 'false');
		
		targetHolder.addClass('st-faint');
		
		targetForm.attr('data-auto', 'true');
		targetForm.attr('data-enabled', 'false');
		
	}
});

$(".postholder").click(function() {

	$(this).removeClass('st-faint');
	var frm = '#' + $(this).attr('id')  +" form";
	$(frm).attr('data-auto', 'false');

});



});