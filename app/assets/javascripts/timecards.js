$(document).ready(function() {
	console.log("sdfldsfd");
	var iphone = navigator.platform == "iPhone";

	function zeroPad(number) {
		var num = number.toString();
		if (num.length == 1) {
			num = "0" + num;
		}
		return num;
	}

	function updateClock() {
		// show
		var clock = $("span.current-time");
		if ($("span.current-time").length > 0) {
			if (clock.attr("value") == "" || clock.attr("value") == undefined) {
				var currentTime = new Date();
				var d = new Date("2016/12/15 " + clock[0].innerText);
				var new_d = new Date("2016/12/15 "+currentTime.getHours()+":"+currentTime.getMinutes()+":"+currentTime.getSeconds());
				var t = new_d - d - 1000;
				var seconds = Math.floor( (t/1000) % 60 );
			  var minutes = Math.floor( (t/1000/60) % 60 );
			  var hours = Math.floor( (t/(1000*60*60)) % 24 );
				clock.attr("value", hours+":"+minutes+":"+seconds);
			}
			var currentTime = new Date();
			var d = new Date("2016/12/15 " + clock.attr("value"));
			var t = currentTime - d;
			var seconds = Math.floor( (t/1000) % 60 );
		  var minutes = Math.floor( (t/1000/60) % 60 );
		  var hours = Math.floor( (t/(1000*60*60)) % 24 );
		  clock[0].innerText = "" + zeroPad(hours) + ":" + zeroPad(minutes) + ":" + zeroPad(seconds);
		}
	};

	if ($("input.stop-button").length > 0) {
		var input = $("input.stop-button");

		input[0].addEventListener('click', function() {
			var field = $(".member-wrap input").first();
			if (field.val() == "") {
				alert("Please enter at least one Team Member.");
			} else {
				var form = field.parent().parent();
				form.submit();
			}
		}, false);

		var add_member = $(".add-member");
		add_member[0].addEventListener('click', function() {
			var wrap = add_member.parent().find(".member-wrap");
			$(wrap[wrap.length - 1]).clone().insertAfter($(".member-wrap")[wrap.length - 1]);
		}, false);
	}
	
	if ($(".current-time").length > 0) {
		var interval = setInterval(function() { updateClock() }, 1000);
	}
	if ($(".timecard-form").length > 0) {

		var select_click = function(e) {
				var e_target;
				if (iphone) {
					var idx = e.target.selectedIndex;
					e_target = $(e.target).find("option")[e.target.selectedIndex];
				} else {
					e_target = e.target;
				}
		    var job_id = e_target.value;
		    var job_div = $(e_target.parentElement.parentElement);
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
								var str = e.target.innerHTML;
						    var task_id = e.target.value;
						    var task_div = $(e.target.parentElement.parentElement.parentElement);
						    task_div.find("input[name='timecard[task_attrs][][bidtask_id]']").attr("value", task_id);
						    task_div.find("input[name='timecard[task_attrs][][name]']").attr("value", str);
							}, true);
			    	}
		    	}
		    });

		};
		var add_task_listeners = function(element) {
			var len = element.find("select.select-task option").length;
			for (var l = 1; l < len; l++) {
				var sel_task = element.find("select.select-task option")[l];
				sel_task.addEventListener('click', function(e) {
					var str = e.target.innerHTML;
			    var task_id = e.target.value;
			    var task_div = $(e.target.parentElement.parentElement.parentElement);
			    task_div.find("input[name='timecard[task_attrs][][bidtask_id]']").attr("value", task_id);
			    task_div.find("input[name='timecard[task_attrs][][name]']").attr("value", str);
				}, false);
			}
		};

		var add_job_listeners = function(element) {
			var len = element.find("select.select-job option").length;
			for (var j = 0; j < len; j++) {
				if (iphone) {
					element.find("select.select-job")[0].addEventListener('change', select_click);
				} else {
					var sel_job = element.find("select.select-job option")[j];
					sel_job.addEventListener('click', select_click, true);
				}
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
		
		var submitbtn = $("input.submit-timecard");
		submitbtn[0].addEventListener('click', function() {
			var sum = parseFloat($(".sum-total-rounded")[0].innerText);
			var total = 0;
			$(".timecard-form input.task-hours-field").each(function() {
				if ($(this).val() == "") {
					alert("Please finish filling out all of the hours fields.");
				}
				var num = parseFloat($(this).val());
				if (isNaN(num)) {
					alert("Please enter valid numbers.");
				}
				total += num;

			});
			if (total != sum) {
				alert("Error - entered hours do not match total (clock time * number of members");
			} else {
				$(".timecard-form input[type='submit']").click();
			}
		}, false);
	}


	

});