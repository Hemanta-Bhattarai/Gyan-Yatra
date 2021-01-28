[Table of content](../README.md)
# Magic Methods

>Magic methods add magic to your class.

Eg. when adding two numbers using `+`, `__add__()` method is called.

Built in class has many magic methods which can be seen using `dir()` method.
Eg. magic methods for `int` is displayed using `dir(int)`
```
['__abs__', '__add__', '__and__', '__bool__', '__ceil__', '__class__', 
'__delattr__', '__dir__', '__divmod__', '__doc__', '__eq__', '__float__',
 '__floor__', '__floordiv__', '__format__', '__ge__', '__getattribute__', 
 '__getnewargs__', '__gt__', '__hash__', '__index__', '__init__', 
 '__init_subclass__', '__int__', '__invert__', '__le__', '__lshift__',
  '__lt__', '__mod__', '__mul__', '__ne__', '__neg__', '__new__', 
  '__or__', '__pos__', '__pow__', '__radd__', '__rand__', '__rdivmod__', 
  '__reduce__', '__reduce_ex__', '__repr__', '__rfloordiv__', '__rlshift__', 
  '__rmod__', '__rmul__', '__ror__', '__round__', '__rpow__', '__rrshift__', 
  '__rshift__', '__rsub__', '__rtruediv__', '__rxor__', '__setattr__', 
  '__sizeof__', '__str__', '__sub__', '__subclasshook__', '__truediv__', 
  '__trunc__', '__xor__', 'as_integer_ratio', 'bit_length', 'conjugate', 
  'denominator', 'from_bytes', 'imag', 'numerator', 'real', 'to_bytes']
```

## Some useful magic methods
1. `__str__()`:
It can be overridden to return a printable string representation of any user defined class.
   Here Complex class is used to demonstrate most of the magic methods overload.
   
```python
class Complex(object):
    def __init__(self,real=0,imag=0):
      self.real = real
      self.imag = imag
    def __str__(self):
        if(self.imag<0):
           return f"{self.real} - {abs(self.imag)}j"
        else:
           return f"{self.real} + {abs(self.imag)}j"


        
        
        
        
#demo of the class
c = Complex(1,1)
print(c)
c2 = Complex(1,-1)
print(c2)

c3 = Complex(0.01, -0.01)
print(c3)

```
2. `__add__()`:
```python


class Complex(object):
   def __init__(self,real=0,imag=0):
      self.real = real
      self.imag = imag
       
    def __str__(self):
      if(self.imag<0):
         return f"{self.real} - {abs(self.imag)}j"
      else:
         return f"{self.real} + {abs(self.imag)}j"
    def __add__(self, other):
       return Complex(self.real + other.real, self.imag + other.imag)
    
    





#demo of the class
c = Complex(1,1)
print(c)
c2 = Complex(1,-1)
print(c2)

c3 = Complex(0.01, -0.01)
print(c3)

c4 = c3 + c2
print(c4)
```
3. `__ge__`: This method can be overridden for `>=`.

Some important Magic Methods

1. Initialization and Construction:

   a. `__new__(cls, other)`: To get called in an object's instantation.
   
   b. `__init__(self, other)`: To get called by the `__new__` method.
   
   c. `__del__(self)`: Destructor method
   
2. Unary operator and functions:

   a.`__pos__(self)`: To get called for unary positive e.g. +someobject
   
   b.`__neg__(self)`: To get called for negative
   
   c.`__abs__(self)`: To get called built_in abs( ) fuction
   
   d. `__invert__(self)`: To get called for inversion using the `~` operator


Total list:
```
__round__(self,n)	        To get called by built-in round() function.
__floor__(self)  	        To get called by built-in math.floor() function.
__ceil__(self)	                To get called by built-in math.ceil() function.
__trunc__(self)	                To get called by built-in math.trunc() function

# Augmented Assignements
__iadd__(self, other)	        To get called on addition with assignment e.g. a +=b.
__isub__(self, other)	        To get called on subtraction with assignment e.g. a -=b.
__imul__(self, other)	        To get called on multiplication with assignment e.g. a *=b.
__ifloordiv__(self, other)      To get called on integer division with assignment e.g. a //=b.
__idiv__(self, other)	        To get called on division with assignment e.g. a /=b.
__itruediv__(self, other)	To get called on true division with assignment
__imod__(self, other)	        To get called on modulo with assignment e.g. a%=b.
__ipow__(self, other)	        To get called on exponentswith assignment e.g. a **=b.
__ilshift__(self, other)	To get called on left bitwise shift with assignment e.g. a<<=b.
__irshift__(self, other)	To get called on right bitwise shift with assignment e.g. a >>=b.
__iand__(self, other)	        To get called on bitwise AND with assignment e.g. a&=b.
__ior__(self, other)	        To get called on bitwise OR with assignment e.g. a|=b.
__ixor__(self, other)	        To get called on bitwise XOR with assignment e.g. a ^=b.

#Type conversion Magic Methods
__int__(self)	                To get called by built-int int() method to convert a type to an int.
__float__(self)	                To get called by built-int float() method to convert a type to float.
__complex__(self)	        To get called by built-int complex() method to convert a type to complex.
__oct__(self)	                To get called by built-int oct() method to convert a type to octal.
__hex__(self)	                To get called by built-int hex() method to convert a type to hexadecimal.
__index__(self)	                To get called on type conversion to an int when the object is used in a slice expression.
__trunc__(self)	                To get called from math.trunc() method.


#String Magic Methods
__str__(self)	                To get called by built-int str() method to return a string representation of a type.
__repr__(self)	                To get called by built-int repr() method to return a machine readable representation of a type.
__unicode__(self)	        To get called by built-int unicode() method to return an unicode string of a type.
__format__(self, formatstr)	To get called by built-int string.format() method to return a new style of string.
__hash__(self)	                To get called by built-int hash() method to return an integer.
__nonzero__(self)	        To get called by built-int bool() method to return True or False.
__dir__(self)	                To get called by built-int dir() method to return a list of attributes of a class.
__sizeof__(self)	        To get called by built-int sys.getsizeof() method to return the size of an object.

#Attribute Magic Methods
__getattr__(self, name)	        Is called when the accessing attribute of a class that does not exist.
__setattr__(self, name, value)	Is called when assigning a value to the attribute of a class.
__delattr__(self, name)	        Is called when deleting an attribute of a class.


# Operator Magic Methods
__add__(self, other)	        To get called on add operation using + operator
__sub__(self, other)	        To get called on subtraction operation using - operator.
__mul__(self, other)	        To get called on multiplication operation using * operator.
__floordiv__(self, other)	To get called on floor division operation using // operator.
__truediv__(self, other)	To get called on division operation using / operator.
__mod__(self, other)	        To get called on modulo operation using % operator.
__pow__(self, other[, modulo])	To get called on calculating the power using ** operator.
__lt__(self, other)	        To get called on comparison using < operator.
__le__(self, other)	        To get called on comparison using <= operator.
__eq__(self, other)	        To get called on comparison using == operator.
__ne__(self, other)	        To get called on comparison using != operator.
__ge__(self, other)	        To get called on comparison using >= operator.

```
