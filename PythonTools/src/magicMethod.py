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
