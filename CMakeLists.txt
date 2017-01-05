cmake_minimum_required(VERSION 2.8.6)
project(PICMake)

set(TARGET_NAME NO_TARGET)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
include(${CMAKE_CURRENT_LIST_DIR}/PICMake.cmake)

# Build things
add_subdirectory(src)

reportTargets()

# Install things
CONFIGURE_FILE("${PROJECT_SOURCE_DIR}/PICMake.cmake" "${PROJECT_BINARY_DIR}/PICMake.cmake")
install(FILES "${PROJECT_BINARY_DIR}/PICMake.cmake" DESTINATION ${CMAKE_ROOT}/Modules)
