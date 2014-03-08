 
        
$(function (){
 
setClickoverButton();  	
});



function setClickoverButton()
{
 $('[rel="clickover"]').clickover(
    	{
    		placement:'bottom',
    		global_close:false,
    		html:true,
    		onShown:handleReplybox,
    		content:'<form id="replyform" action=""><textarea id="txtarea" name="content" placeholder="Enter your reply here">sdadasd</textarea><input type="submit" value="Post" class="btn btn-success"></form>'
    	}
    );
    $('[rel="clickover"]').click(function()
    {
    	$("#replyform").attr('action',$(this).attr('href'));
    	return false;
    });
    
      	
}  



function handleReplybox()
{
 
 setTimeout(function(){$("#txtarea").wysihtml5();},1000);
 $('#replyform').submit(function() {  
    var valuesToSubmit = $(this).serialize();
    $.ajax({
    	type: 'post',
        url: $(this).attr('action'), //sumbits it to the given url of the form
        data: valuesToSubmit,
        dataType: "script" // you want a difference between normal and ajax-calls, and json is standard
    }).success(function(json){
        //act on result.(
    });
    return false; // prevents normal behaviour
});
}

function streamRemovefeed(id)
{
	$("#stream-feed-"+id).remove(); 
}
