$(document).ready(function() {

	google.charts.load('current', {'packages':['corechart']});
  google.charts.setOnLoadCallback(drawChart);
  function drawChart() {
  	var tasks = $(".task");

  	for (var i = 0; i < tasks.length; i++) {
  		var task = $(tasks[i]);
  		var bidhours = parseFloat(task.find("span.bid-hours")[0].innerText);
  		var bidqty = parseFloat(task.find("span.bid-qty")[0].innerText);
  		var actualhours = task.find("span.actual-hours")[0].innerText;
  		var actualqty = task.find("span.actual-qty")[0].innerText;

  		//For each actual data point:
  		var actuals = task.find("div.actual");
  		var totalactualhours = 0;
  		var totalactualqty = 0;
  		var bidqtytotal = 0;
  		
  		var dataTableArr = [[0, 0, null]];

  		if (actuals.length > 0) {
	  		for (var j = 0; j < actuals.length; j++) {
	  			var actual = $(actuals[j]);

	  			var new_actualhrs = parseFloat(actual.find(".actlhrs")[0].innerText);
	  			var new_actualqty = parseFloat(actual.find(".actlqty")[0].innerText);

		  		//array = [total + new actual hours, total + new qty total, bid qty total]

		  		newarr = [[totalactualhours + new_actualhrs, totalactualqty + new_actualqty, null]];

	  			dataTableArr = dataTableArr.concat(newarr);
	  			totalactualhours += new_actualhrs;
	  			totalactualqty += new_actualqty;
	  		}
	  		// draw remaining bid
  			dataTableArr = dataTableArr.concat([[0, null, 0], [bidhours, null, bidqty]]);
	  		var remaining = totalactualhours - bidhours;
	  		
	  		if (remaining > 0) {
	  			dataTableArr = dataTableArr.concat([[bidhours + remaining, null, bidqty]]); // (flat line)
	  		}
		    var data = new google.visualization.DataTable();
		    data.addColumn('number', 'X');
	      data.addColumn('number', 'Actual qty');
	      data.addColumn('number', 'Bid qty');
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
	          title: 'Hours',
	          maxValue: Math.max(bidhours, totalactualhours)
	        },
	        vAxis: {
	          title: 'Quantity',
	          maxValue: Math.max(bidqty, totalactualqty)
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