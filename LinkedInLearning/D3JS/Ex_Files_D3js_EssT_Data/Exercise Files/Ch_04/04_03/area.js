var dataArray = [25, 26, 28, 32, 37, 45, 55, 70, 90, 120, 135, 150, 160, 168, 172, 177, 180]
var dataYears = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17"]


var height = 200;
var width = 500;

var area = d3.area()
                .x(function(d,i){return i*20;})
                .y0(height)
                .y1(function(d){return height - d;});



var svg = d3.select("body").append("svg").attr("height","100%").attr("width","100%");
svg.append("path").attr("d",area(dataArray));
                
















//there are 20 generators 

//d3 api to see generators. look for version 4.
//d3 generators



//github.com/d3/


//bl.ocks.org/ to see accounts


//d3 blocks for histogram to search for histogram
