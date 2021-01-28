const testWrapper = document.querySelector(".test-wrapper");
const testArea = document.querySelector("#test-area");
const originText = document.querySelector("#origin-text p").innerHTML;
const resetButton = document.querySelector("#reset");
const theTimer = document.querySelector(".timer");
var timer = [0,0,0];
var interval;
var timerRunning = false;



// Run a standard minute/second/hundredths timer:
function runTimer(){
    timerUpdate();
    prettyPrint();

}


function timerUpdate(){
    timer[2]++;
    if(timer[2] == 100){
        timer[1]++;
        timer[2] = 0
    }
    

    if(timer[1] == 60){
        timer[0]++;
        timer[1] = 0
    }
}

function leadingZero(time){
    if(time<10){
        time = "0" + time;
    }
    return(time);
}
function prettyPrint(){

    timer[0] = leadingZero(timer[0]);
    timer[1] = leadingZero(timer[1]);
    timer[2] = leadingZero(timer[2]);



    theTimer.innerHTML = timer[0] + ":" + timer[1] + ":" + timer[2];


    timer[0] = parseInt(timer[0]);    
    timer[1] = parseInt(timer[1]);    
    timer[2] = parseInt(timer[2]);    

}



// Match the text entered with the provided text on the page:
function spellCheck(){
    let textEntered = testArea.value;
    let originTextMatch = originText.substring(0,textEntered.length) //subtring(start_index, end_index)
    console.log("Entered : " + textEntered)
    console.log("Orginal :" + originTextMatch)

    if(textEntered == originText){
        testWrapper.style.borderColor = "green";
        clearInterval(interval);  //stop the setInterval
    }
    else{
        if(textEntered == originTextMatch){
            testWrapper.style.borderColor = "blue";

        }
        else{
            testWrapper.style.borderColor = "red";
        }
    

    }

}

// Start the timer:
function start(){
    let textEnteredLength = testArea.value.length;
    if (textEnteredLength === 0 && !timerRunning){
        timerRunning = true;
        interval = setInterval(runTimer,10);
        
}
}

// Reset everything:
function reset(){
    clearInterval(interval);
    interval = null;
    timer = [0,0,0];
    timerRunning = false;
    
    testArea.value = "";
    theTimer.innerHTML ="00:00:00";
    testWrapper.style.borderColor = "grey";

}

// Event listeners for keyboard input and the reset button:
testArea.addEventListener("keypress",start,false);
testArea.addEventListener("keyup",spellCheck,false);
resetButton.addEventListener("click",reset,false);
