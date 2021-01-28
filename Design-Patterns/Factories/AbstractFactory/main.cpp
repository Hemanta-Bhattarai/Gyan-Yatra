#include<iostream>


#include "DrinkFactory.hpp"




int main()
{
  DrinkFactory df;
  auto c = df.make_drink("coffee");


  return 0;
}
