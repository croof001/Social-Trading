  $(function (){ 
     $('.rateit').on('reset rated',function (e,f) {
         var ri = $(this);
 
         //if the use pressed reset, it will get value: 0 (to be compatible with the HTML range control), we could check if e.type == 'reset', and then set the value to  null .
         var value = ri.rateit('value');
         if (e.type == 'reset')
         {
           value = null;
         }
         var feedurl = ri.data('url'); // if the product id was in some hidden field: ri.closest('li').find('input[name="productid"]').val()
         
         //maybe we want to disable voting?
        
         
         
         $.ajax({
            url: feedurl,
            type: 'PUT',
            dataType: "json",
            contentType: "application/json",
            data: JSON.stringify({rating: value}),
            processData: false,
            success: function (msg) {$.notify(msg.message, 'success'); },
            error: function (msg) {$.notify('Error in connection. Unable to record your rating', 'error'); }
         } 
       );
         
         
         
     });
    
 });
