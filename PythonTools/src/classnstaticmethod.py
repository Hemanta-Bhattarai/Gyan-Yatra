class Student(object):
    def __init__(self, first_name, last_name):
        self.first_name = first_name
        self.last_name = last_name

    def getFirst(self):
        return self.first_name
        
scott = Student('Scott','Hartley')
print(scott.getFirst())

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



class StudentClassMethodNew(object):
    totalCount = 0
    def __init__(self, first_name, last_name):
        self.first_name = first_name
        self.last_name = last_name
        StudentClassMethodNew.totalCount += 1

    @classmethod
    def from_string(cls, name_str):
        first_name, last_name = map(str,name_str.split(' '))
        student = cls(first_name, last_name)
        return student
    
    @classmethod
    def getCount(cls):
        return cls.totalCount
    
    @staticmethod
    def printGreetings():
        print("Hello. Welcome!!")
    

    def getFirst(self):
        return self.first_name
    
print("Start of program")
print(StudentClassMethodNew.getCount())
StudentClassMethodNew.printGreetings()
scott = StudentClassMethodNew.from_string('Scott Hartley')
print(scott.getFirst())
print(scott.getCount())
scott.printGreetings()
jesus = StudentClassMethodNew.from_string('Jesus Christ')
print(jesus.getFirst())
print(StudentClassMethodNew.getCount())


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
print("Name of person is : ",p.name)
del p.name


