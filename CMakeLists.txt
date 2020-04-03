cmake_minimum_required(VERSION 2.8)
project(PICMake)

include(${CMAKE_CURRENT_LIST_DIR}/cmake/PICMake.cmake)# Use PICMake

pi_git_hash(GIT_VERSION)

message("GIT_VERSION: " ${GIT_VERSION})

if(FALSE)# Tree style
  add_subdirectory(src)
else()  # All in one
  pi_add_target(StaticLibDemo STATIC src/StaticLibDemo)
  pi_add_target(SharedLibDemo SHARED src/SharedLibDemo)
  pi_add_target(AppDemo BIN src/AppDemo DEPENDENCY StaticLibDemo SharedLibDemo REQUIRED OpenCV)
  pi_add_target(ConditionalApp BIN src/ConditionalApp MODULES PIL Qt System REQUIRED OpenCV)
endif()

pi_report_target()

# Install things
pi_install(CMAKE ${PROJECT_SOURCE_DIR}/cmake/PICMake.cmake.in)
