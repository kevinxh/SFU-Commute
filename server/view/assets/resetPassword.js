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
		//return initial state first
		$("#pw").removeClass( "border-danger" );
		$("#pw2").removeClass( "border-danger" );
		$("#error").text("");

		var pw = $("#pw").val();
		var pw2 = $("#pw2").val();

		if(pw.length === 0){
			$("#pw").addClass( "border-danger" );
			$("#error").text("Please enter your new password.");
		} else if (pw.length < 6 || pw.length > 15) {
			$("#pw").addClass( "border-danger" );
			$("#error").text("Please enter a 6-15 digits password.");
		} else if (pw2.length === 0) {
			$("#pw2").addClass( "border-danger" );
			$("#error").text("Please enter repeat password.");
		} else if (pw2.length < 6 || pw2.length > 15) {
			$("#pw2").addClass( "border-danger" );
			$("#error").text("Please enter a 6-15 digits password.");
		} else if(pw !== pw2){
			$("#pw").addClass( "border-danger" );
			$("#pw2").addClass( "border-danger" );
			$("#error").text("Passwords does not match");
		} else {
			var token = getParameterByName('token');
			console.log(token);
		}
	})
});

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