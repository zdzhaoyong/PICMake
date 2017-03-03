# share library 1
add_library(DemoLibShared SHARED DemoLibShared.cpp)

add_executable(DemoApp1 DemoApp1.cpp)
target_link_libraries(DemoApp1 DemoLibShared SharedLibDemo StaticLibDemo)

add_executable(DemoApp2 DemoApp2.cpp)
target_link_libraries(DemoApp2 DemoLibShared SharedLibDemo StaticLibDemo)

include_directories(
${PROJECT_SOURCE_DIR}/src
)

#include_directories(
#${PROJECT_SOURCE_DIR}/src
#)
#set(TARGET_NAME ClassLoaderTest)
#set_property( GLOBAL APPEND PROPERTY LIBS2COMPILE  " ${CMAKE_SHARED_LIBRARY_PREFIX}TestLibrary${CMAKE_SHARED_LIBRARY_SUFFIX}")
#set_property( GLOBAL APPEND PROPERTY APPS2COMPILE  " ${TARGET_NAME}")

