####################################################################
## STANDARD CMAKE CONFIGURATION FOR CMakeLists.txt
## VERSION 1.0.0 at 2017.01.04 by Yong Zhao
## 
## Please include this file at the last line of your Project CMakeLists.txt
## Things need to be set: MODULES, MAKE_TYPE
####################################################################
cmake_minimum_required(VERSION 2.8.6)

set(PICMAKE_VERSION "1.0.0")
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/packages)
#message(CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH})

if(NOT PICMAKE_UTILS_LOADED)
	include(${CMAKE_CURRENT_LIST_DIR}/PICMakeUtils.cmake)
endif()

if(NOT PICMAKE_UTILS_LOADED)
	message(FATAL_ERROR "Unable to find PICMakeUtils at folder ${CMAKE_CURRENT_LIST_DIR}")
endif()

set(CMAKE_BASE_FROM_DIR ${CMAKE_CURRENT_SOURCE_DIR})
#message(CMAKE_CURRENT_SOURCE_DIR: ${CMAKE_CURRENT_SOURCE_DIR})

# 1. set TARGET_NAME as the folder name and replace space to ‘_'
if(NOT TARGET_NAME STREQUAL "NO_TARGET")
	get_filename_component(TARGET_NAME ${CMAKE_BASE_FROM_DIR} NAME)
	string(REPLACE " " "_" TARGET_NAME ${TARGET_NAME} )
else()
	unset(SOURCE_FILES_ALL)
endif()

# 2. check if it is the project directory, and find all packages if it is
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BASE_FROM_DIR)
	if(NOT PROJECT_NAME)
		project(${TARGET_NAME})
		message("Start project ${TARGET_NAME}")
	endif()
	
	foreach(MODULES_IT ${MODULES})
		find_package(${MODULES_IT} QUIET)
		if(NOT ${${MODULES_IT}_FOUND})
			message(FATAL_ERROR "Failed to find package ${MODULES_IT}")
		endif()
	endforeach()

	foreach(IT ${MODULES})
		PIL_ECHO_LIBINFO(${IT})
	endforeach()
endif()

# 3. Collect all source files and dependencies
if((NOT TARGET_NAME STREQUAL "NO_TARGET") AND (NOT SOURCE_FILES_ALL))
	if(NOT PICMAKE_SOURCE_DIR)
		set(PICMAKE_SOURCE_DIR ${CMAKE_BASE_FROM_DIR})
	endif()
	#message("Collecting source files from ${CMAKE_BASE_FROM_DIR}")
	file(GLOB_RECURSE SOURCE_FILES_ALL RELATIVE ${CMAKE_BASE_FROM_DIR} ${PICMAKE_SOURCE_DIR}/*.cpp ${PICMAKE_SOURCE_DIR}/*.c ${PICMAKE_SOURCE_DIR}/*.cc)
	
	filtSOURCE_FILES_ALL("CMakeFiles")
	#message("Collected ${SOURCE_FILES_ALL}")
endif()

# 4. Pasing configuration
if(SOURCE_FILES_ALL AND NOT MAKE_TYPE)
	autosetMakeType()
endif()


#message("SOURCE_FILES_ALL:" ${SOURCE_FILES_ALL})

if(SOURCE_FILES_ALL AND NOT TARGET_NAME STREQUAL "NO_TARGET")

	foreach(MODULE_NAME ${MODULES})
		list(APPEND COMPILEFLAGS ${${MODULE_NAME}_INCLUDES})
		list(APPEND LINKFLAGS    ${${MODULE_NAME}_LIBRARIES})
	endforeach()

	include_directories(${COMPILEFLAGS})

	if(MAKE_TYPE STREQUAL "bin")
		set_property( GLOBAL APPEND PROPERTY APPS2COMPILE  " ${TARGET_NAME}")
		add_executable(${TARGET_NAME} ${CMAKE_BASE_FROM_DIR} ${SOURCE_FILES_ALL})
	elseif(MAKE_TYPE STREQUAL "static")
		set_property( GLOBAL APPEND PROPERTY LIBS2COMPILE  " ${CMAKE_STATIC_LIBRARY_PREFIX}${TARGET_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")
		add_library(${TARGET_NAME} STATIC ${CMAKE_BASE_FROM_DIR} ${SOURCE_FILES_ALL})
	elseif(MAKE_TYPE STREQUAL "shared")
		set_property( GLOBAL APPEND PROPERTY LIBS2COMPILE  " ${CMAKE_SHARED_LIBRARY_PREFIX}${TARGET_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}")
		add_library(${TARGET_NAME} SHARED ${CMAKE_BASE_FROM_DIR} ${SOURCE_FILES_ALL})
	else()
		message ("No such make type: " ${MAKE_TYPE})
		unset(MAKE_TYPE)
	endif()

	if(MAKE_TYPE)
	target_link_libraries(${TARGET_NAME} ${LINKFLAGS})
		if(MOC_FILES)
			set_target_properties(${TARGET_NAME} PROPERTIES AUTOMOC TRUE)
		endif()
	endif()
endif()


unset(TARGET_NAME)
unset(PICMAKE_SOURCE_DIR)
unset(SOURCE_FILES_ALL)
set(PICMAKELIST_LOADED TRUE)
