#include <iostream>
#include <cmath>

#define PI 3.14159265359

using namespace std;


enum class PointType
{
  cartesian,
  polar

};

class Point{

  Point(float x, float y): x(x), y(y){}
  class PointFactory;  

  public:
  float x, y;
  friend ostream &operator <<(ostream& os, const Point& point){
    os<<"x: "<<point.x<< " y: "<<point.y;
    return os;
  }
  
  static PointFactory Factory;

private:
  class PointFactory{
    PointFactory(){} 
    public:
      static Point Cartesian(float x, float y){
        return {x,y};
      }  
        
      static Point Polar(float r, float theta){
        return {r* cos(theta), r* sin(theta)}; 
      }
  
  };
  



};


//concrete factory



int main()
{
    
  auto p = Point::Factory.Polar( 5, PI/4);
  cout<< p <<endl;
  return 0;
}
