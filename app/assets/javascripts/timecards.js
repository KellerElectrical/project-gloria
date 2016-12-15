$(document).ready(function() {
	console.log("sdfldsfd");
	var len = $(".timecard-form select.select-job option").length;
	for (var j = 0; j < len; j++) {
		var sel_job = $(".timecard-form select.select-job option")[j];
		
		sel_job.addEventListener('click', function(e) {
	    
	    var job_id = e.target.value;
	    var urljobs = "/jobs/" + job_id + "/get_tasks";
	    $.get(urljobs, function(data) {
	    	var htmlstr = "";
	    	for (var i = 0; i < data.length; i++) {
	    		
		    	// JSON object: {"bidtask_ids": [{"1":"Name1"},{""} 2, 3, 4]}
	    		htmlstr += '<option value="' + data[i]["id"] + '">' + data[i]["name"] + '</option>';
	    	}
	    	$(".timecard-form select.select-task").html(htmlstr);
	    });

		}, false);
	}

	var task_fields = $(".task-fields");	
	var fields = $(".task-fields .fields"); // there should be only one on document ready

	len = $(".timecard-form select.select-task option").length;
	for (var k = 0; k < len; k++) {
		var sel_task = $(".timecard-form select.select-task option")[k];
		sel_task.addEventListener('click', function(e) {
	    
	    var task_id = e.target.value;
	    $("input [name='timecard[task_id][]']").attr("value", task_id);

		}, false);
	}

	var add_btn = $(".add-task")[0];
	add_btn.addEventListener('click', function() {
		var thing = $(".select-task-wrap-wrap").clone();
		thing.insertAfter($(".select-task-wrap-wrap")[0]);
	}, false);


});