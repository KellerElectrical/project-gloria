$(document).ready(function() {

	google.charts.load('current', {'packages':['corechart']});
  google.charts.setOnLoadCallback(drawChart);
  function drawChart() {
  	var tasks = $(".task");

  	for (var i = 0; i < tasks.length; i++) {
  		var task = $(tasks[i]);
  		var bidhours = task.find("span.bid-hours")[0].innerText;
  		var bidqty = task.find("span.bid-qty")[0].innerText;
  		var actualhours = task.find("span.actual-hours")[0].innerText;
  		var actualqty = task.find("span.actual-qty")[0].innerText;

  		//For each actual data point:
  		var actuals = task.find("div.actual");
  		var totalactualhours = 0;
  		var totalactualqty = 0;
  		var bidhourtotal = 0;
  		
  		var dataTableArr = [[0, 0, 0]];

  		if (actuals.length > 0) {

	  		for (var j = 0; j < actuals.length; j++) {
	  			var actual = $(actuals[j]);

	  			var new_actualhrs = parseFloat(actual.find(".actlhrs")[0].innerText);
	  			var new_actualqty = parseFloat(actual.find(".actlqty")[0].innerText);
	  			// Get Field Value for Units Per Hour
	  			// ???
	  			// quite possibly insecure
	  			var hpu = parseFloat(task.find(".hours-per-unit").val());
	  			
	  			// convert to float?
		  		bidhourtotal += hpu * new_actualqty; 
		  		//array = [total + new actual hours, total + new qty total, bid qty total]

		  		newarr = [[totalactualqty + new_actualqty, totalactualhours + new_actualhrs, bidhourtotal]];

	  			dataTableArr = dataTableArr.concat(newarr);
	  			totalactualhours += new_actualhrs;
	  			totalactualqty += new_actualqty;
	  		}
		    var data = new google.visualization.DataTable();
		    data.addColumn('number', 'X');
	      data.addColumn('number', 'Actual hours');
	      data.addColumn('number', 'Bid hours');
	      data.addRows(dataTableArr);
	/*[
		      ['Year', 'Sales', 'Expenses'],
		      ['2004',  1000,      400],
		      ['2005',  1170,      460],
		      ['2006',  660,       1120],
		      ['2007',  1030,      540]
		    ]*/
		    var options = {
	        hAxis: {
	          title: 'Quantity'
	        },
	        vAxis: {
	          title: 'Hours'
	        },
	        colors: ['#a52714', '#097138'],
	        crosshair: {
	          color: '#000',
	          trigger: 'selection'
	        }
	      };

		    var chart = new google.visualization.LineChart(document.getElementsByClassName("task_chart")[i]);

		    chart.draw(data, options);
  		}
  	}
  };
});