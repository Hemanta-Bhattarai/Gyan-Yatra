
var height = 300;
var width = 500;

var linspace = require('@stdlib/math/utils/linspace');
//to know about stdlib visit https://stdlib.io/docs/api/v0.0.90/

var arr = linspace(0,100,6);
console.log(arr.length);



//var y = d3.scaleLinear()
//            .domain([0,max])
//            .range([height,0]);
//var x = d3.scaleTime()
//            .domain([minDate,maxDate])
//            .range([0,width]);
//var yAxis = d3.axisLeft(y);
//var xAxis = d3.axisBottom(x);
//
//var svg = d3.select("body").append("svg").attr("height","100%").attr("width","100%");
//
//var margin = {left:50,right:50,top:40,bottom:0};
//
//var chartGroup = svg.append("g")
//            .attr("transform","translate("+margin.left+","+margin.top+")");
//
//var line = d3.line()
//                .x(function(d){ return x(d.month); })
//                .y(function(d){ return y(d.price); });
//
//chartGroup.append("path").attr("d",line(data));
//chartGroup.append("g").attr("class","x axis").attr("transform","translate(0,"+height+")").call(xAxis);
//chartGroup.append("g").attr("class","y axis").call(yAxis);
//
//
//
