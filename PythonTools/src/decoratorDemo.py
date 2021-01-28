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



def timeit(function):
    import time
    def wrapper():
        start = time.time()
        func = function()
        end = time.time()
        print(f"Elapsed time is ${end-start}")
        return 0
    return wrapper

@uppercase_decorator
def printHelloWorld():
    return("Hello world!")


@split
@uppercase_decorator
def printUpperSplit():
    return("Hello world!")



@timeit
def timingLoop():
    i = 0
    i_end = 100000
    while(i<i_end):
        i = i + 1
    return 0



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





def main():
    #basic decorator
    print("Demo for use of basic decorator:")
    result = printHelloWorld()
    print(result)


    #two decorators working together
    print("Demo for two decorator ( Upper and Split) working together:")
    result = printUpperSplit()
    print(result)

    #timing decorator
    print("Demo one of useful decorator to print time of execution.")
    timingLoop()


    #timing decorator with args
    print("Demo one of useful decorator to print time of execution with arguments.")
    n_end = 100
    print(f"Demo with n-end ${n_end}")
    timingLoopWithArg(n_end)
    n_end = 1e7
    print(f"Demo with n-end ${n_end}")
    timingLoopWithArg(n_end)

if __name__ == "__main__":
    main()
