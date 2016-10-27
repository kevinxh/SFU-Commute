$( document ).ready(function() {

	$("#pw").on('input',function() {
		if($("#pw").val().length > 15){
			$("#pw").addClass("border-danger");
		} else {
			$("#pw").removeClass( "border-danger" );
		}
	});

	$("#pw2").on('input',function() {
		if($("#pw2").val().length > 15){
			$("#pw2").addClass("border-danger");
		} else {
			$("#pw2").removeClass( "border-danger" );
		}
	});

	$("#btn").click(function(){
		
		$("#pw").removeClass( "border-danger" );
		$("#pw2").removeClass( "border-danger" );
		$("#pw").removeClass( "animated shake" );
		$("#pw2").removeClass( "animated shake" );
		$("#error").text("");

		var pw = $("#pw").val();
		var pw2 = $("#pw2").val();

		if(pw.length === 0){
			$("#pw").addClass( "border-danger" );
			$('#pw').addClass('animated shake');
			$("#error").text("Please enter your new password.");
		} else if (pw.length < 6 || pw.length > 15) {
			$("#pw").addClass( "border-danger" );
			$('#pw').addClass('animated shake');
			$("#error").text("Please enter a 6-15 digits password.");
		} else if (pw2.length === 0) {
			$("#pw2").addClass( "border-danger" );
			$('#pw2').addClass('animated shake');
			$("#error").text("Please enter repeat password.");
		} else if (pw2.length < 6 || pw2.length > 15) {
			$("#pw2").addClass( "border-danger" );
			$('#pw2').addClass('animated shake');
			$("#error").text("Please enter a 6-15 digits password.");
		} else if(pw !== pw2){
			$("#pw").addClass( "border-danger" );
			$("#pw2").addClass( "border-danger" );
			$("#error").text("Passwords does not match");
		} else {
			$('#btn').prop('disabled', true);
			$("#btn").html( "<i class=\"fa fa-refresh fa-spin\"></i>" );
			var token = getParameterByName('token');

			$.ajax({
			    url: "http://54.69.64.180/reset",
			    data: {
			        token: token,
			        password: pw,
			    },
			    type: "POST",
			    dataType : "json",
			})
			  .done(function(res) {
			     if (res.success){
			     	success();
			     }
			  })
			  .fail(function( xhr, status, errorThrown ) {
			  	$('#btn').prop('disabled', false);
			  	$("#btn").html( "Reset" );
			  	$("#error").text(errorThrown);
			    alert( "Sorry, there was a problem! Please try again later." );
			    console.log( "Error: " + errorThrown );
			    console.log( "Status: " + status );
			    console.dir( xhr );
			  });
		}
	})
});

function success(){
	$("#pw").remove();
	$("#pw2").remove();
	$("#btn").remove();
	$(".form-modal-title").text("Congrats, you have successfully reset your password!");
	$(".form-modal-heading").addClass( "animated bounceInDown" );
}

function getParameterByName(name, url) {
    if (!url) {
      url = window.location.href;
    }
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}