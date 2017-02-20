$(document).ready(function() {
	console.log("Loaded user_share_location");
	if ("geolocation" in navigator) {
  	console.log("geolocation is available");
  	
  	navigator.geolocation.getCurrentPosition(function(position) {
			$.ajax({
				url: "/user_locations",
				method: "PUT",
				data: {
					"lat": position.coords.latitude,
					"long": position.coords.longitude
				},
				success: function(response) {
					console.log("Successfully updated user with address:" + response["address"]);
				}
			});
		});

	} else {
	  console.log("geolocation IS NOT available")
	}
});