$(document).ready(function() {
	console.log("sdfldsfd");

	function updateClock() {
		// show
		var clock = $("span.current-time");
		if ($("span.current-time").length > 0) {
			if (clock.attr("value") == "" || clock.attr("value") == undefined) {
				var currentTime = new Date();
				var d = new Date("2016-12-15T" + clock[0].firstChild.data);
				var new_d = new Date("2016-12-15T"+currentTime.getHours()+":"+currentTime.getMinutes()+":"+currentTime.getSeconds());
				var t = new_d - d - 1000;
				var seconds = Math.floor( (t/1000) % 60 );
			  var minutes = Math.floor( (t/1000/60) % 60 );
			  var hours = Math.floor( (t/(1000*60*60)) % 24 );
				clock.attr("value", hours+":"+minutes+":"+seconds);
			}
			var currentTime = new Date();
			var d = new Date("2016-12-15T" + clock.attr("value"));
			var t = currentTime - d;
			var seconds = Math.floor( (t/1000) % 60 );
		  var minutes = Math.floor( (t/1000/60) % 60 );
		  var hours = Math.floor( (t/(1000*60*60)) % 24 );
		  clock[0].firstChild.nodeValue = "" + hours + ":" + minutes + ":" + seconds;
		}
	}
	if ($(".current-time").length > 0) {
		var interval = setInterval(function() { updateClock() }, 1000);
	}
	if ($(".timecard-form").length > 0) {

	var select_click = function(e) {
	    var job_id = e.target.value;
	    var job_div = $(e.target.parentElement.parentElement);
	    var urljobs = "/jobs/" + job_id + "/get_tasks";
	    $.get(urljobs, function(data) {
	    	var htmlstr = "<option value='' ></option>";
	    	for (var i = 0; i < data.length; i++) {
	    		
		    	// JSON object: {"bidtask_ids": [{"1":"Name1"},{""} 2, 3, 4]}
	    		htmlstr += '<option value="' + data[i]["id"] + '">' + data[i]["name"] + '</option>';
	    	}
	    	job_div.find("select.select-task").html(htmlstr);
	    	var len = job_div.find("select.select-task").length;
	    	for (var m = 0; m < len; m++) {
	    		var div = $(job_div.find("select.select-task")[m]);
		    	div.parent().parent().find("input[name='timecard[task_attrs][][job_id]']").attr("value", job_id);
		    	for (var l = 1; l < data.length + 1; l++) {

		    		var sel_task = div.find("option")[l];
						sel_task.addEventListener('click', function(e) {
					    var task_id = e.target.value;
					    var task_div = $(e.target.parentElement.parentElement.parentElement);
					    task_div.find("input[name='timecard[task_attrs][][bidtask_id]']").attr("value", task_id);
					    task_div.find("input[name='timecard[task_attrs][][name]']").attr("value", sel_task.firstChild.data);
						}, false);
		    	}
	    	}
	    });

	};
	var add_task_listeners = function(element) {
		var len = element.find("select.select-task option").length;
		for (var l = 1; l < len; l++) {
			var sel_task = element.find("select.select-task option")[l];
			sel_task.addEventListener('click', function(e) {
				    
		    var task_id = e.target.value;
		    var task_div = $(e.target.parentElement.parentElement.parentElement);
		    task_div.find("input[name='timecard[task_attrs][][bidtask_id]']").attr("value", task_id);
		    task_div.find("input[name='timecard[task_attrs][][name]']").attr("value", sel_task.firstChild.data);
			}, false);
		}
	};
	var add_job_listeners = function(element) {
		var len = element.find("select.select-job option").length;
		for (var j = 0; j < len; j++) {
			var sel_job = element.find("select.select-job option")[j];
			
			sel_job.addEventListener('click', select_click, false);
		}
	};
	add_job_listeners($(".timecard-form"));

	var task_fields = $(".task-fields");	
	var fields = $(".task-fields .fields"); // there should be only one on document ready

	len = $(".timecard-form select.select-task option").length;
	for (var k = 0; k < len; k++) {
		
	}

	var add_btn = $(".add-task")[0];
	var empty_tasks = $(".select-task-wrap-wrap").clone(true);
	var click_function = function(e) {
		var btn = $(e.target);
		var clone = btn.parent().find(".select-task-wrap-wrap").last().clone(true, true);
		clone.insertAfter($(btn).parent().find(".select-task-wrap-wrap").last());
		// use method to find select_task in the new fields, go through each and add event handler
		$(btn).parent().find(".add-task")[0].addEventListener('click', click_function, false);
		add_task_listeners(clone);
	};

	add_btn.addEventListener('click', click_function, false);

	var add_btn2 = $(".add-job")[0];
	var empty_jobs = $(".select-job-wrap").clone(true);
	var click_function2 = function() {
		var jobwrap = $($(add_btn2.parentElement).find(".select-job-wrap").last()[0]);
		var clone = empty_jobs.clone(true);
		clone.insertAfter(jobwrap);
		clone.find(".add-task")[0].addEventListener('click', click_function, false);
		add_job_listeners(clone);
	};
	add_btn2.addEventListener('click', click_function2, false);
	}

});