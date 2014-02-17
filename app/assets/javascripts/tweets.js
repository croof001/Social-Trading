$(function() {
	$('.chosen-select').chosen({});

	$('#datepicker1').datetimepicker({
		onClose : function(a) {
			$('#datepicker1').change();
		}
	});

	$("#filter-button-1").click(function() {
		$("#filter-button-1").css('visibility', 'hidden');
	});

	$("#filter-button-2").click(function() {
		$("#filter-button-1").css('visibility', 'visible');
	});
	
	$('.tooltiphosts').tooltip();

});

function removeTweet(id) {
	$('#tweet' + id).remove();
}

function notifyFetch()
{
	$.notify('We are fetching tweets for all your keywords.', 'success');
	setTimeout(function()
	{
		$.notify('Looking for new tweets', 'info');
		Filterrific.submitFilterForm();
	},10000);
}
