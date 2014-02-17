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

});

function removeTweet(id) {
	$('#tweet' + id).remove();
}

