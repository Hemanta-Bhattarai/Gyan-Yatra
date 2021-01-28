 # Bash scripting dissection
## Learn basic bash scripting 

### Variables:: Line 5
```
    number of Sim=10000
```
Variable definition in bash script:

```
NAME="John"
number=100
```
Printing Variable:
```
echo $NAME
echo ${NAME}
echo "$NAME"
echo '$NAME'
printf "%s" $NAME
printf "$NAME"

```
The difference between '$NAME' and "$NAME" is, the first one doesn't expand the variable i.e "John" but the second one expands the variable. The output of the first one '$NAME' is $NAME but the second is "$NAME" John.

### Function definition:: Line 9
```
   function_name() {
    ---statements---
    ---statements---
}
```
usage() in Line 9. is the function defined which prints out the help statement for the arguments to be passed in to the script. Note if function takes the argument then it can be accessed inside the function using $1, $2 ... $n. For example if you want to pass two numbers , and it and print out the sum. It is done as:

**sum function**
```
sum(){
    first_num=$1
    second_num=$2
    sum_num=$first_num + $second_num
    echo "$sum_num"

}
```
To use it we must call the function with two arguments:
```
    sum 1 2
```
To store the output of this function to a variable we should use 
```
varName=$(commands)

```
The above syntax takes the output of command and assigins its value to the variable name.


### Conditional execution:: Line 18

```
    if [[ condition check ]];then
        ....statements.....
    elif [[ condition check ]];then
        ...statements.....
    else
        ...statements....
    fi
```
**note**: [[ is a command which returns 0(true) or 1(false) for condition check.

*Different condition checks*
```
-z STRING        Empty string
-n STRING        Not emtpy string
str1 == str2     Equal
str1 != str2     Not equal
num1 -eq num2      Equal(num is for numbers)
num1 -ne num2      Not equal
num1 -lt num2      less than
num1 -gt num2      greater than
num1 -le num2      less or equal
num1 -ge num2      greater or equal
str1 =- str2       regular expression
! expr             not
&&                 and operations
||                 or operations
-b FILE - True if the FILE exists and is a block special file.
-c FILE - True if the FILE exists and is a special character file.
-d FILE - True if the FILE exists and is a directory.
-e FILE - True if the FILE exists and is a file, regardless of type (node, directory, socket, etc.).
-f FILE - True if the FILE exists and is a regular file (not a directory or device).
-G FILE - True if the FILE exists and has the same group as the user running the command.
-h FILE - True if the FILE exists and is a symbolic link.
-g FILE - True if the FILE exists and has set-group-id (sgid) flag set.
-k FILE - True if the FILE exists and has a sticky bit flag set.
-L FILE - True if the FILE exists and is a symbolic link.
-O FILE - True if the FILE exists and is owned by the user running the command.
-p FILE - True if the FILE exists and is a pipe.
-r FILE - True if the FILE exists and is readable.
-S FILE - True if the FILE exists and is socket.
-s FILE - True if the FILE exists and has nonzero size.
-u FILE - True if the exists and set-user-id (suid) flag is set.
-w FILE - True if the FILE exists and is writable.
-x FILE - True if the FILE exists and is executable.
file1 -nt file2    1 is more  recent than 2 (new to)
file1 -ot file2    2 is more recent than 1 (old to)
file1 -ef file2    same files (equal file)

    
```
In Line  18. we have used the conditional statements to check if the plot flag is set to 1 or not.

And in Line 32. we have used it to check if the file exists or not.

### Case statements:: Line 35

```
case $var in
    pattern1) --statements-- ;;
    pattern2) --statements-- ;;
    pattern3) --statements-- ;;
esac
```
Here, the $var that matches the pattern number is executed. The patterns are regex type patterns. In Line 38. the pattern * is meant for the default or otherwise.

### Numerical Calculations:: Line 45

```
#add 200 to $a and store to b
b=$((a+200))

```
We can also use bc program. bc performs the mathematical calculation where expression is passed as string. Mathematical calculation is be do by using echo and pipe(|) operation. In Line 45. we have used bc and scale is precision after decimal place.
```
#divide var2 by var1 set precision level to 4
var=$(echo "scale=4;$var2/$var1"|bc)
```
`echo "scale=4;$var2/$var1"|bc` is command to perform calculation and $(...) assigns output of command to variable name.

### Parsing arguments in bash:: Line 63
```
while getopts "----option---pattern" option_carrier; do
    case ${option_carrier} in
        option1) ----statement1----;;
        option2) ----statement2----;;
        option3) ----statement3----;;
        :) error handling if argument is not passed to selected option;;
        \?) error invalid option name
    esac
done
```
In Line 63. the option pattern is ":hn:po:r:", the starting : ensures disable the defualt error handling of invalid options. Its good to always use this, so that itcatches the invalid options used. h,n,p,o,r are the options that can be passed to the script. The : following the options implies argument for that option is to be passed else error is caught. the option argument is stored in $OPTARG. `while` statement is also a looping statement which will be explained latter. 

### Redirection
```
python hello.py > output.txt  # stdout to (file)
python hello.py >> output.txt # stdout to (file), append
python hello.py 2> error.log # stderr to (file)
python hello.py 2>&1    #stderr to stdout
python hello.py 1>&2   #stdout to stderr
python hello.py 2>/dev/null #stderr to (null)
python hello.py < foo.txt #feed foo.txt to stdin for python
```
Note: 1 is file descriptor for `stdout` and 2 is file descriptor for `stderr`. &1 and &2 indicates the reference the value of the file descriptor 1 and 2. `2>&1` means you are saying "Redirect the `stderr` to same place we are redirecting the stdout"


### Default values:: Line 76
```
${FOO:-val}    # $FOO or val is not set
${FOO:=val}    # set $FOO to val if not set
${FOO:+val}    # val if $FOO is set
${FOO:?message} # show error message and exit if $FOO is set
```
In Line 76. plotFlag has value of $plotFlag if set otherwise set to 0.
### Loops:: Line 88

```
for var in list_of_files or sequence {start..end..(step)}; do
    echo $var
done

```
C++ style for loop
```
for ((i=0;i<100;i++)); do
    echo $i
done
```
while loop:
```
while ---condition----;do
    ----statements----
done
```

### Reading file using loop
```
IFS="\n"
while read line; do
    echo $line
done < input_file
```
Here, IFS is the **internal field separator** or delimiter. If we want to get tab separated data we can use `IFS="\t"`

### Substitution(get prefix and suffix):: Line 105
```
${FOO%suffix}    #removes suffix
${FOO#prefix}    #removes prefix
${FOO%%suffix}   #removes long suffix
${FOO##prefix}   #removes long prefix
${FOO/from/to}   #replace first match of `from` in `$FOO` to `to`
${FOO//from/to}  #replace all from found
${FOO/%from/to}  #replace suffix
${FOO/#from/to}  #replace prefix

```
### Here string and Here document:: Line 107
`<<<` denotes here string. 
```
cat <<< "Hi there"
hi there
```
`<<` denotes here is document
```
cat << EOF
    hi
    I
    am
    fine
EOF
```
In the first case the three arrow means a string is directed and in second case two arrow means a document is directed. The start of file is from EOF and ends at EOF. 

NOTE: EOF can be any string.

# Some more syntax

## Arguments in function or script
```
$#     #Number of arguments
$@      #All arguments starting from first
$1      #first argument
```

## String manipulation
```
${name/J/j}         #substitute J for j
${name:0:2}         #slice character from 0 to 2
${name::2}          #slicing first two
${name::-1}         #slice except last
${name:(-1)}        #slice 1 character from last
```
## Arrays
```
#Define arrays

fruit=('Apple','Orange','Banana')

#Get entries
fruit[0]

#Some operations
fruit=("${fruit[@]}""Watermelon")           #push new fruit
fruit+=('Watermelon')                       #push new fruit
fruit=(${fruit[@]/pattern/})                #remove by regex match with pattern
fruit=("${fruit[@]}""${Veggies[@]}")        #conctenate

#working with arrays
${fruit[@]}         #All element space-separated
${#fruit[@]}        #number of element
${#fruit[3]}        #lenth of 3rd element
${fruit[@]:3:2}     #range from pos 3 to len 2 i.e gives 3rd and 4th element
```
For more information you can look [Bash Script Cheat Sheet](https://devhints.io/bash)
