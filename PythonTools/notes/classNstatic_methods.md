[Table of content](../README.md)
# Class and Static methods

## @classmethod

Decorators that create class method where actual class object is passed in function call like
`self` in ordinary methods of class. `@classmethod` has mandatory first argument which is 
uninstantiated class itself. The keyword for first argument in `@classmethod` is `cls`.

```python
#normal methods

class Student(object):
    def __init__(self, first_name, last_name):
        self.first_name = first_name
        self.last_name = last_name
        
scott = Student('Scott','Hartley')


#class method

class StudentClassMethod(object):
    def __init__(self, first_name, last_name):
        self.first_name = first_name
        self.last_name = last_name

    @classmethod
    def from_string(cls, name_str):
        first_name, last_name = map(str,name_str.split(' '))
        student = cls(first_name, last_name)
        return student


    def getFirst(self):
        return self.first_name
scott = StudentClassMethod.from_string('Scott Hartley')
print(scott.getFirst())

```

Main benefit of this is we can instantiate the class using different methods like
```python

class StudentClassMethod(object):
    def __init__(self, first_name, last_name):
        self.first_name = first_name
        self.last_name = last_name

    @classmethod
    def from_string(cls, name_str):
        first_name, last_name = map(str,name_str.split(' '))
        student = cls(first_name, last_name)
        return student
    
    @classmethod
    def from_csv(cls, name_csv):
        ...
        ...
        ...
        return student


    @classmethod
    def from_pickel(cls, name_pickel):
        ...
        ...
        ...
        return student
    
    
scott = StudentClassMethod.from_string('Scott Hartley')
print(scott.getFirst())
```


## @staticmethod
The @staticmethod is a built-in decorator that defines a static method 
in the class in Python. A static method doesn't receive any reference 
argument whether it is called by an instance of a class or by the class itself.
```python
class StudentClassMethod(object):
    totalCount = 0
    def __init__(self, first_name, last_name):
        self.first_name = first_name
        self.last_name = last_name
        StudentClassMethod.totalCount += 1

    @classmethod
    def from_string(cls, name_str):
        first_name, last_name = map(str,name_str.split(' '))
        student = cls(first_name, last_name)
        return student
    
    @classmethod
    def getCount(cls):
        return cls.totalCount
    
    
print("Start of program")
print(StudentClassMethod.getCount())
scott = StudentClassMethod.from_string('Scott Hartley')
print(scott.getFirst())
print(scott.getCount())

jesus = StudentClassMethod.from_string('Jesus Christ')
print(jesus.getFirst())
print(StudentClassMethod.getCount())

```

## @property
@property decorator allows us to define properties. `@property` also comes
with `setter` and `deleter` functionality.
```python

# without @property decorator
class Person:
    def __init__(self, name):
        self._name = name

    def get_name(self):
        print('Getting name')
        return self._name

    def set_name(self, value):
        print('Setting name to ' + value)
        self._name = value

    def del_name(self):
        print('Deleting name')
        del self._name

    # Set property to use get_name, set_name
    # and del_name methods
    name = property(get_name, set_name, del_name, 'Name property')

p = Person('Adam')
print(p.name)
p.name = 'John'
del p.name

#with @property decorator
class person(object):
    def __init__(self):
        self.__name=''
    @property
    def name(self): # similar to getter 
        return self.__name
    @name.setter    #setter
    def name(self, value):
        self.__name=value
    @name.deleter # deleter
    def name(self):
        print('Deleting..')
        del self.__name
        
        
        
p = person()
p.name = "Steve"
print("Name of person is : " p.name)
del p.name




```
