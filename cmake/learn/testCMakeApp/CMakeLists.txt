# + testCMakeApp
# -- main.cpp
# -- CMakeLists.txt

cmake_minimum_required(VERSION 2.8) 
project(testCMakeApp)

set(CMAKE_AUTOMOC ON)

find_package(Qt4 REQUIRED) # find Qt4

include_directories(${QT_INCLUDES})
add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME} Qt4::QtGui Qt4::QtXml)

