
var margin = {left:50,right:50,top:50,bottom:0};
var height = 300;
var width = 300;





var svg = d3.select("body").append("svg").attr("height","80%").attr("width","100%");


var chartGroup = svg.append("g")
            .attr("transform","translate("+margin.left+","+margin.top+")");

var chartGroupPi = svg.append("g")
                        .attr("transform",`translate(${width+margin.left*2},${2*margin.top})`);


//chartGroup.selectAll("circle").data(sinWave).enter().append("circle")
//                    .attr("cx",function(d){return x(d.x);})
//                    .attr("cy",function(d){return y(d.y);})
//                    .attr("stroke","blue")
//                    .attr("r","1");
//


var rectData = [{x:0,y:0,h:height,w:width}];

chartGroup.selectAll("rect")
            .data(rectData)
            .enter().append("rect")
            .attr("x",function(d){return d.x;})
            .attr("y",function(d){return d.y;})
            .attr("height",function(d){return d.h;})
            .attr("width",function(d){return d.w;});



var circData = [{cx:height/2, cy:width/2,r:height/2}];
var circNormal = "fill:white;"
var circInColor = "fill:green;"
var circOutColor = "fill:indianred;"
chartGroup.selectAll("circle")
            .data(circData)
            .enter().append("circle")
            .attr("class","outerCircle")
            .attr("stroke","blue")
            .attr("style",`${circNormal}`)
            .attr("cx",function(d){return d.cx;})
            .attr("cy",function(d){return d.cy;})
            .attr("r",function(d){return d.r});


var numSamples = 0;
var totalSamples = 1000
var pi = 0
var dartOut = 0
var piMean = 0
var y = d3.scaleLinear()
            .domain([0,3.5])
            .range([height/2,0]);
var x = d3.scaleLinear()
            .domain([0,totalSamples])
            .range([0,2*width]);



var yAxis = d3.axisLeft(y);
var xAxis = d3.axisBottom(x);



var timer = d3.interval(function() {
                                 
                                var styleAttr = circInColor;
                                var x_cod = Math.random()*width;
                                var y_cod = Math.random()*height;
                                var r2 = (x_cod - (width/2))**2 + (y_cod - (height/2))**2;
                               if(r2>height**2/4) {
                                        styleAttr = circOutColor;
                                        ++dartOut;
                                        }
                                var dotData = [{"cx":x_cod,"cy":y_cod}];
                                chartGroup.selectAll("circle"+numSamples)
                                            .data(dotData)
                                            .enter().append("circle")
                                            .attr("cx",function(d){return d.cx;})
                                            .attr("cy",function(d){return d.cy;})
                                            .attr("stroke","blue")
                                            .attr("style",`${styleAttr}`)
                                            .attr("r","4");

        ++numSamples;

                                pi = 4*((numSamples - dartOut)/numSamples);
                                piMean = ((numSamples - 1)*piMean + pi)/numSamples;
                               var piData = [{"it":numSamples,"pi":pi}];
                            
                                chartGroupPi.selectAll("circlePi"+numSamples)
                                            .data(piData)
                                            .enter().append("circle")
                                            .attr("cx",function(d){return x(d.it);})
                                            .attr("cy",function(d){return y(d.pi);})
                                            .attr("stroke","black")
                                            .attr("style",`${styleAttr}`)
                                            .attr("r",".5");

        if( numSamples > totalSamples){
            timer.stop();
            timer = null;     
        }
                            


  },1);



//chartGroup.append("path").attr("d",line(sinWave));
chartGroupPi.append("g").attr("class","x axis").attr("transform","translate(0,"+height/2+")").call(xAxis);
chartGroupPi.append("g").attr("class","y axis").call(yAxis);

//var numSamplesPerFrame = 1;
//var numSamples = 1;
//var timer1 = d3.timer(function() {
//                                chartGroup.selectAll("circle"+numSamples)
//                                            .data(sinWave)
//                                            .enter().append("circle")
//                                            .attr("cx",function(d){return x(d.x);})
//                                            .attr("cy",function(d){return y(d.y+numSamples*.1);})
//                                            .attr("stroke","blue")
//                                            .attr("r","10");
//        console.log(numSamples);
//        ++numSamples;
//        if( numSamples > 10){
//            timer1.stop();
//            timer1 = null;     
//        }
//  });
