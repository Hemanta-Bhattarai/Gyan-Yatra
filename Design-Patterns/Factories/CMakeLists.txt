cmake_minimum_required(VERSION 3.12)
project(Design_Patterns)

set(CMAKE_CXX_STANDARD 14)
add_executable(designFactoryMethod FactoryMethod.cpp)
add_executable(designFactory Factory.cpp)
add_executable(designInnerFactory InnerFactory.cpp)

