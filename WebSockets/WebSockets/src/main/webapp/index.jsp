<!DOCTYPE html>
<meta charset="utf-8">
<html>

<head>
	<style>
		body {
		  font: 10px sans-serif;
		}
		
		.axis path,
		.axis {
		  fill: none;
		  stroke: #000;
		  shape-rendering: crispEdges;
		}
		
		.line {
		  fill: none;
		  stroke: steelblue;
		  stroke-width: 1.5px;
		}	
	</style>

</head>

<body>
	<div id="chart"></div>
</body>

	<script src="js/d3.js"></script>
	<script>
		var events = [];	
		var REFRESH_FREQUENCY = 750;
		var X_SIZE = 2 * 60 * 1000;	
		
		var margin = {top: 6, right: 0, bottom: 20, left: 60};
		var width = 960 - margin.right;
		var height = 400 - margin.top - margin.bottom;
		
		var x = d3.time.scale()
		 	.range([0, width]);
		
		var y = d3.scale.linear()
		 	.range([height, 0]);
		y.domain([0, 100000]);			
		      
		var xAxis = d3.svg.axis()
			.scale(x)
			.orient("bottom");
		
		var yAxis = d3.svg.axis()
		    .scale(y)
		    .orient("left");	
		
		var chartElement = d3.select("div#chart")
			.append("svg")
			.attr("width", 1020)
			.attr("height", 400)
			.append("g")
			.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

		var xline = chartElement.append("g")
			.attr("class", "axis")
			.attr("transform", "translate(0," + height + ")")
			.call(xAxis);
		
		var yline = chartElement.append("g")
			.attr("class", "axis")
			.call(yAxis);
				
		function redraw() {		
		      // join event data to points on the graph
		      // see http://bost.ocks.org/mike/join
		      var circle = chartElement.selectAll("circle")
		          .data(events);
		
		      circle.enter().append("circle")
		          .style("stroke", "black")
		          .style("fill", "blue")
		          .attr("cx", function(d) { return x(d.date) })
		          .attr("cy", function(d) { return y(d.amount) })
		          .attr("r", 0)
		          .transition().duration(REFRESH_FREQUENCY)
		          .attr("r", 5);
		
		      circle.transition()
		          .duration(REFRESH_FREQUENCY)
		          .ease("linear")
		          .attr("cx", function(d) { return x(d.date) });
		
		      circle.exit().transition()
		          .duration(REFRESH_FREQUENCY)
		          .attr("r", 0)
		          .ease("linear")
		          .attr("cx", function(d) { return x(d.date) })
		          .remove();
		
		      // update the timeline range
		      var now = Date.now();
		      x.domain([now - X_SIZE, now - REFRESH_FREQUENCY]);
		
		      // slide the x-axis left
		      xline.transition()
		            .duration(REFRESH_FREQUENCY)
		            .ease("linear")
		            .call(xAxis)
		            .each("end", redraw);		
		}
		redraw();
		
		var socket = new WebSocket("ws://<%=request.getLocalAddr()%>:<%=request.getServerPort()%>/dashboard");
		
		function dateReviver(key, value) {
		    if (key == 'date') {
	            return new Date(value);
		    }
		    return value;
		};
		
		socket.onmessage = function(event) {
			var event = JSON.parse(event.data, dateReviver)
			events.push(event);
			console.log(event.amount + " - " + (event.date.getMinutes()) + ":" + (event.date.getSeconds()));		  
		};		
	</script>
</html>
