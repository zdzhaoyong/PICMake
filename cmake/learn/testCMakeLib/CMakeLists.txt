# + testCMakeLib
# -- showImage.cpp
# -- showImage.h
# -- CMakeLists.txt

cmake_minimum_required(VERSION 2.8)
project(showImage)


find_package(OpenCV REQUIRED) # find OpenCV

include_directories(${OPENCV_INCLUDES})

add_library(${PROJECT_NAME} SHARED showImage.cpp)
target_link_libraries(${PROJECT_NAME} opencv_highgui)
