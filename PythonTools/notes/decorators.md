[Table of content](../README.md)
## Decorators in python

A decorator is a design pattern in Python that allows a user to add 
new functionality to an existing object without modifying its structure.
Decorators are usually called before the definition of a function you
want to decorate. In this tutorial, we'll show the reader how they can 
use decorators in their Python functions.


Example of decorator:
```python

def uppercase_decorator(function):
    def wrapper():
        func = function()
        make_upper = func.upper()
        return make_upper
    
    return wrapper


@uppercase_decorator
def printHelloWorld():
    return "Hello world!"



printHelloWorld()


```
Above function takes function as a argument and returns a wrapper function which returns 
a specific job to output of input function. These are decorators. Use of decorators
The output of above code is `HELLO WORLD`.


Sometimes two decorators can be combined
```python

def uppercase_decorator(function):
    def wrapper():
        func = function()
        make_upper = func.upper()
        return make_upper

    return wrapper



def split(function):
    def wrapper():
        func = function()
        split_string = func.split()
        return split_string
    return wrapper


@split
@uppercase_decorator
def printUpperSplit():
    return("Hello world!")


print(printUpperSplit())
```
The output of above code is `['HELLO','WORLD!']`.

One of the useful decorator could be time profiling of a function
```python
def timeit(function):
    import time
    def wrapper():
        start = time.time()
        func = function()
        end = time.time()
        print(f"Elapsed time is ${end-start}")
        return 0
    return wrapper

@timeit
def timingLoop():
    i = 0
    i_end = 100000
    while(i<i_end):
        i = i + 1
    return 0

timingLoop()
```
Until now we are dealing with function without any arguments. Lets try to 
decorating a function that takes arguments
```python

def timeitWithArgs(function):
    import time
    def wrapper_accept_args(arg):
        start = time.time()
        func = function(arg)
        end = time.time()
        print(f"Elapsed time is ${end-start}.")
        return 0
    return wrapper_accept_args


@timeitWithArgs
def timingLoopWithArg(n_end):
    i = 0
    i_end = n_end
    while(i<i_end):
        i = i + 1
    return 0

timingLoopWithArg()

```
Decorating function with variable number of arguments `*args` and `**kwargs`.
```python
def decoratorForFuncWithManyArgs(function):
    def wrapper_with_many_args(*args, **kwargs):
        print("The positional args are", args)
        print("The keyword args are", kwargs)
        function(*args,**kwargs)
    return wrapper_with_many_args

@decoratorForFuncWithManyArgs
def function_with_diff_args(*args,name="Employee")
    print(f"Salary of ${name} is ${sum(args)}")



function_with_diff_args(1,2,3,4,name="John")
```



Passing arguments to decorators
```python
def decorator_maker_with_arguments(decorator_arg1, decorator_arg2, decorator_arg3):
    def decorator(func):
        def wrapper(function_arg1, function_arg2, function_arg3) :
            "This is the wrapper function"
            print("The wrapper can access all the variables\n"
                  "\t- from the decorator maker: {0} {1} {2}\n"
                  "\t- from the function call: {3} {4} {5}\n"
                  "and pass them to the decorated function"
                  .format(decorator_arg1, decorator_arg2,decorator_arg3,
                          function_arg1, function_arg2,function_arg3))
            return func(function_arg1, function_arg2,function_arg3)

        return wrapper

    return decorator

pandas = "Pandas"
@decorator_maker_with_arguments(pandas, "Numpy","Scikit-learn")
def decorated_function_with_arguments(function_arg1, function_arg2,function_arg3):
    print("This is the decorated function and it only knows about its arguments: {0}"
           " {1}" " {2}".format(function_arg1, function_arg2,function_arg3))

decorated_function_with_arguments(pandas, "Science", "Tools")


```
