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


    private:
        Point(float x, float y): x(x), y(y){}
    
    public:
        float x, y;
    
        static Point Cartesian(float x, float y)
        {
            return {x,y};
        }
    
        static Point Polar(float r, float theta){
            return {r* cos(theta), r* sin(theta)}; 
        }


        friend ostream &operator <<(ostream& os, const Point& point){
            os<<"x: "<<point.x<< " y: "<<point.y;
            return os;

        }

};








int main()
{

    auto p = Point::Polar( 5, PI/4);
    cout<< p <<endl;
    return 0;
}
