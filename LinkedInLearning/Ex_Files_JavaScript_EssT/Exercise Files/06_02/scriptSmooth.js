const HOURHAND = document.querySelector("#hour");
const MINUTEHAND = document.querySelector("#minute");
const SECONDHAND = document.querySelector("#second");


let hrPosition = 0;
let minPosition = 0;
let secPosition = 0;
var date = new Date();

let hr = date.getHours();
let min = date.getMinutes();
let sec = date.getSeconds();


console.log(hr+":"+min+":"+sec)
function Hour2Deg(hour,min,sec){

    hour += min/60 + sec/3600;
    return 360*hour/12;
}



function Min2Deg(min,sec){
    min += sec/60;
    return 360*min/60;
}

function Sec2Deg(sec){
    return 360*sec/60;
}

hrPosition = Hour2Deg(hr,min,sec);
minPosition = Min2Deg(min,sec);
secPosition = Sec2Deg(sec);


function runClock(){
    secPosition += 360 * (1/60);  
    minPosition += 6/60;  
    hourPosition += 3/360;  
    
    HOURHAND.style.transform = "rotate(" + hrPosition + "deg)";
    MINUTEHAND.style.transform = "rotate(" + minPosition + "deg)";
    SECONDHAND.style.transform = "rotate(" + secPosition + "deg)";
}




var interval = setInterval(runClock, 1000); //run function every 1000ms
