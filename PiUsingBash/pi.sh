#!/bin/bash
#calculation of pi using random numbers
#This script has most of the commands used in bash script

numberOfSim=10000



usage(){

    echo "pi [-h] [-n number_of_sim_points] [-r radius_of_circle] [-p(flag for plot)] [-o output_file_name]"
}




simInfo(){
    if [[ $plotFlag -eq 1 ]] ; then
        stringPlot="True"
    else
        stringPlot="False"
    fi
    printf "\t\t+++++++++++++++++++++++++++++\t\t\n"
    printf "\t\t+ Simulation information    +\t\t\n"
    printf "\t\t+ Number of darts: %d       +\n" $numberOfSim
    printf "\t\t+ PlottingFlag: $stringPlot +\n"
    printf "\t\t+++++++++++++++++++++++++++++\n"
}

checkFile(){

if [[ -f $outputFile ]];then
    printf "\nFILE:%s exist. Do you want to delete it(y/n)\n" $outputFile
    read -n 1 deleteFlag
    case $deleteFlag in 
        [yY]) rm $outputFile; printf "\nFILE:$outputFile deleted!!!!!\n";;
        [nN]) printf "\n$outputFile not deleted. Re-run the program. Program Terminating...\n"; sleep 1; exit 2;;
        *) printf "Please enter yes or no. Program Terminating.....\n";sleep 1; exit 3;; 
    esac
fi

}
random(){
    randMax=32767
    randomNumber=$( echo "scale=5;$RANDOM/$randMax" | bc )
    randomNumberInRange=$( echo "$randomNumber - 0.5"|bc )
}

randomUsingPython(){

    randomNumberInRange=$( python -c "import random; print random.uniform(-$radius,$radius)")
}
testInside()
{
    
    dist2=$(echo "scale=4;$x*$x+$y*$y"|bc)
    if (( $( echo "$dist2<$radius*$radius" | bc -l ) )); then
        insideFlag="True";
    else
        insideFlag="False";
    fi
}
while getopts ":hn:po:r:" opt; do
    case ${opt} in
        h) usage
           exit 1 ;;
        n) numberOfSim=$OPTARG;;
        p) plotFlag=1 ;;
        o) outputFile=$OPTARG;;
        r) radius=$OPTARG;;
        :) echo "Invalid option: $OPTARG requires an argument" 1>&2;exit 1 ;;
        \?) echo "Invalid option: $OPTARG " 1>&2; exit 2 ;;
    esac
done

plotFlag=${plotFlag:=0}
radius=${radius:=1}
outputFile=${outputFile:="piData.dat"}


simInfo
checkFile


inside=0
pi=0
echo "Simulation started"
for ((i = 1 ; i <= $numberOfSim ; i++ )); do
    echo -ne "$i dart thrown."\\r 
    randomUsingPython;x=$randomNumberInRange
    randomUsingPython;y=$randomNumberInRange
    testInside
    if [[ $insideFlag == "True" ]];then
        inside=$(( inside + 1 ))
    fi
    pi=$( echo "scale=5; 4 * $inside/$i" | bc )
    echo $i $pi>>$outputFile
done

echo "Simulation completed."

printf "Estimated value of pi for %d darts is %f.\n" $numberOfSim $pi
if [[ $plotFlag -eq 1 ]];then
    echo "Plotting..."
    plotName=${outputFile%.*}

    gnuplot -persist <<- EOF
        set xlabel "iterations"
        set ylabel "value of pi"
        set title "Pi Simulator"   
        set term png
        set output "${plotName}.png"
        plot "${outputFile}" using 1:2 title "data"
EOF
fi

 
