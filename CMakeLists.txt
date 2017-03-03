cmake_minimum_required(VERSION 2.6)
project(PICMake)


# set bin & lib to given directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/libs)

# Build things

include(${CMAKE_CURRENT_LIST_DIR}/cmake/PICMake.cmake)# Use PICMake

pi_collect_packages(VERBOSE)# Try to collect all packages from your system

if(FALSE)# Tree style
  add_subdirectory(src)
else()  # All in one
  pi_add_target(StaticLibDemo STATIC src/StaticLibDemo)
  pi_add_target(SharedLibDemo SHARED src/SharedLibDemo)
  pi_add_target(AppDemo BIN src/AppDemo REQUIRED StaticLibDemo SharedLibDemo)
  pi_add_target(ConditionalApp BIN src/ConditionalApp MODULES Qt PIL QGLViewer REQUIRED OpenCV)
endif()

pi_report_target()

# Install things
pi_install(CMAKE ${PROJECT_SOURCE_DIR}/PICMake.cmake)
