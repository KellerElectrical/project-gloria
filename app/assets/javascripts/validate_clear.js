$(document).ready(function() {


	if ($(".validate-clear-btn").length > 0) {
		var btn = $(".validate-clear-btn")[0];
		btn.addEventListener('click', function() {

			var prompt = "Are you sure? This will delete all of the following records:\n\n" +
													" - Jobs\n" +
													" - Tasks\n" +
													" - Employee Timecards\n\n" +
													" Type 'y' to confirm.\n";
			var answer = window.prompt(prompt);
			if (answer === 'Y' || answer === 'y' ) {

				var working_msg = $("<br/><span><i>Working...</i></span>");
				working_msg.insertAfter(btn);
				$.ajax({
					url: "/admin_db_clear",
					method: "DELETE",
					success: function(response, status) {
						working_msg.remove();
						$("<br/><span>Database successfully cleared.</span>").insertAfter(btn);
						$(btn).attr("disabled", "disabled");
					},
					error: function(response, status) {
						working_msg.remove();
						$("<br/><span>Database clear unsuccessful. (status: " + status + ")</span>").insertAfter(btn);
						$(btn).attr("disabled", "disabled");
					}
				});

			}
		});
	}
});