$(document).ready(function() { 
		$(".box").mouseover(function() {
			$(this).fadeTo("fast", 1);
		}); 
		
		$(".box").mouseout(function() {
			$(this).fadeTo("fast", 0.1);
		}); 
});
