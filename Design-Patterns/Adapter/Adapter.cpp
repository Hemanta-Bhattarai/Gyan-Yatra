#include<iostream>

using namespace std;
struct Square
{
  int side{ 0 };


  explicit Square(const int side)
    : side(side)
  {
    cout<<"Square with side "<<side<<" formed.\n";
  }
};

struct Rectangle
{
  virtual int width() const = 0;
  virtual int height() const = 0;

  int area() const
  {
    return width() * height();
  }
};

struct SquareToRectangleAdapter : Rectangle
{

  private:
    const Square& square;

  public:
  SquareToRectangleAdapter(const Square& square):square(square){ cout<<"Square Converted to rectangle\n";}

  int width() const override{
    return square.side;
  }

  int height() const override{
    return square.side;
  }

};



int main(){

  Square smallSquare{5};
  SquareToRectangleAdapter smallRectangle{smallSquare};  
  int area{};
  area = smallRectangle.area();
  cout<<"Area of rectangle converted from square is: "<< area <<endl;

  





  return 0;
}
