# This module supports requiring a minimum version, e.g. you can do
#   find_package(PIL 1.1.1)
# to require version 1.1.1 or newer of PIL, support after 1.1.1.
#
# Once done this will define
#
#  PIL_FOUND - system has PIL lib with correct version
#  PIL_INCLUDES  - the PIL include directory
#  PIL_LIBRARIES - the PIL libraries
#  PIL_VERSION - PIL version


# Copyright (c) 2016 Yong Zhao, <zd5945@126.com>
# Copyright (c) 2016 Shuhui Bu, <bushuhui@gmail.com>

# Find at least 1.1.0
if(NOT PIL_FIND_VERSION)
  if(NOT PIL_FIND_VERSION_MAJOR)
    set(PIL_FIND_VERSION_MAJOR 1)
  endif(NOT PIL_FIND_VERSION_MAJOR)
  if(NOT PIL_FIND_VERSION_MINOR)
    set(PIL_FIND_VERSION_MINOR 1)
  endif(NOT PIL_FIND_VERSION_MINOR)
  if(NOT PIL_FIND_VERSION_PATCH)
    set(PIL_FIND_VERSION_PATCH 0)
  endif(NOT PIL_FIND_VERSION_PATCH)

  set(PIL_FIND_VERSION "${Eigen3_FIND_VERSION_MAJOR}.${Eigen3_FIND_VERSION_MINOR}.${Eigen3_FIND_VERSION_PATCH}")
endif(NOT PIL_FIND_VERSION)

macro(pil_check_version)
  file(READ "${PIL_INCLUDE_DIR}/base/PIL_VERSION.h" _pil_version_header)

  string(REGEX MATCH "define[ \t]+PIL_VERSION_MAJOR[ \t]+([0-9]+)" _pil_major_version_match "${_pil_version_header}")
  set(PIL_VERSION_MAJOR "${CMAKE_MATCH_1}")
  string(REGEX MATCH "define[ \t]+PIL_VERSION_MINOR[ \t]+([0-9]+)" _pil_minor_version_match "${_pil_version_header}")
  set(PIL_VERSION_MINOR "${CMAKE_MATCH_1}")
  string(REGEX MATCH "define[ \t]+PIL_VERSION_PATCH[ \t]+([0-9]+)" _pil_patch_version_match "${_pil_version_header}")
  set(PIL_VERSION_PATCH "${CMAKE_MATCH_1}")

  set(PIL_VERSION ${PIL_VERSION_MAJOR}.${PIL_VERSION_MINOR}.${PIL_VERSION_PATCH})
  if(${PIL_VERSION} VERSION_LESS ${PIL_FIND_VERSION})
    set(PIL_VERSION_OK FALSE)
  else(${PIL_VERSION} VERSION_LESS ${PIL_FIND_VERSION})
    set(PIL_VERSION_OK TRUE)
  endif(${PIL_VERSION} VERSION_LESS ${PIL_FIND_VERSION})

	get_filename_component(PIL_PATH "${PIL_INCLUDE_DIR}/../" ABSOLUTE)
  
  if(NOT PIL_VERSION_OK)

    message(STATUS "PIL version ${PIL_VERSION} found in ${PIL_PATH}, "
                   "but at least version ${PIL_FIND_VERSION} is required")
  endif(NOT PIL_VERSION_OK)
endmacro(pil_check_version)


FIND_PATH( PIL_INCLUDE_DIR base/PIL_VERSION.h base/PIL_VERSION.h
	# installation selected by user
	$ENV{PIL_PATH}/src
	$ENV{PIL_HOME}/src
	/data/zhaoyong/Program/Apps/PIL/src
	# system placed in /usr/local/include
	@CMAKE_INSTALL_PIL_ROOT@/pil
	@CMAKE_INSTALL_PIL_ROOT@/src
	@CMAKE_INSTALL_PIL_ROOT@/include
)

if(PIL_INCLUDE_DIR)
	pil_check_version()
	set(PIL_INCLUDES ${PIL_PATH} ${PIL_INCLUDE_DIR})
endif(PIL_INCLUDE_DIR)


if(PIL_FIND_COMPONENTS)
	set(PIL_FIND_COMPONENTS_COPY ${PIL_FIND_COMPONENTS})
else(PIL_FIND_COMPONENTS)
	set(PIL_FIND_COMPONENTS_COPY base network hardware gui cv)
endif(PIL_FIND_COMPONENTS)

if(WIN32)
	if( PIL_VERSION_OK )

		# test for 64 or 32 bit
		if( CMAKE_SIZEOF_VOID_P EQUAL 8 )
			SET( BUILD_DIR ${PIL_PATH}/build/x64 )
		else( CMAKE_SIZEOF_VOID_P EQUAL 8 )
			SET( BUILD_DIR ${PIL_PATH}/build/x86 )
		endif( CMAKE_SIZEOF_VOID_P EQUAL 8 )
		
		# MINGW
		if(MINGW)
			SET(PIL_LIBRARY_DIR ${BUILD_DIR}/mingw/lib/)
			file(GLOB PIL_LIBRARIES "${PIL_LIBRARY_DIR}*[0-9][0-9][0-9].dll.a")
		endif(MINGW)
		
		# Visual Studio 9
		if(MSVC90)
			SET(PIL_LIBRARY_DIR ${BUILD_DIR}/vc9/lib/)
			file(GLOB PIL_RELEASE_LIBS "${PIL_LIBRARY_DIR}*[0-9][0-9][0-9].lib")
			file(GLOB PIL_DEBUG_LIBS "${PIL_LIBRARY_DIR}*[0-9][0-9][0-9]d.lib")
		endif(MSVC90)
		
		# Visual Studio 10
		if(MSVC10)
			SET(PIL_LIBRARY_DIR ${BUILD_DIR}/vc10/lib/)
			file(GLOB PIL_RELEASE_LIBS "${PIL_LIBRARY_DIR}*[0-9][0-9][0-9].lib")
			file(GLOB PIL_DEBUG_LIBS "${PIL_LIBRARY_DIR}*[0-9][0-9][0-9]d.lib")
		endif(MSVC10)

		if(PIL_LIBRARIES)
			SET ( PIL_FOUND 1 )
			foreach(PIL_MODULE_NAME ${PIL_FIND_COMPONENTS_COPY})
				string(TOUPPER ${PIL_MODULE_NAME} PIL_MODULE_NAME_UPPER)
				set(PI_${PIL_MODULE_NAME_UPPER}_INCLUDES ${PIL_INCLUDES})
				set(PI_${PIL_MODULE_NAME_UPPER}_LIBRARIES ${PIL_LIBRARIES})
				set(PI_${PIL_MODULE_NAME_UPPER}_FOUND 1)
			endforeach()
		else(PIL_LIBRARIES)
			message( STATUS "Looking for PIL-${PIL_FIND_VERSION} or greater  - found ${PIL_VERSION} but no library available." )
			SET ( PIL_FOUND 0 )
		endif(PIL_LIBRARIES)

	else( PIL_VERSION_OK )
		message( STATUS "Looking for PIL-${PIL_FIND_VERSION} or greater  - not found" )
		SET ( PIL_FOUND 0 )
	endif( PIL_VERSION_OK )

ELSE(WIN32) # Linux


	if(PIL_VERSION_OK)

		foreach(PIL_MODULE_NAME ${PIL_FIND_COMPONENTS_COPY})
			string(TOUPPER ${PIL_MODULE_NAME} PIL_MODULE_NAME_UPPER)
			FIND_LIBRARY(PI_${PIL_MODULE_NAME_UPPER}_LIBRARIES NAMES pi_${PIL_MODULE_NAME}
				PATHS
				${PIL_PATH}/libs
				${PIL_PATH}/lib
				)

			#MESSAGE( STATUS "Looking for PIL module '${PIL_MODULE_NAME}'" )
			#MESSAGE( STATUS "Found PIL module '${PIL_MODULE_NAME}' at ${PI_${PIL_MODULE_NAME}_LIBRARIES}" )

			if(PI_${PIL_MODULE_NAME_UPPER}_LIBRARIES)
				set(PI_${PIL_MODULE_NAME_UPPER}_INCLUDES ${PIL_INCLUDES})
				set(PI_${PIL_MODULE_NAME_UPPER}_FOUND 1)
				list(APPEND PIL_LIBRARIES ${PI_${PIL_MODULE_NAME_UPPER}_LIBRARIES})
			else(PI_${PIL_MODULE_NAME_UPPER}_LIBRARIES)
				if(PIL_FIND_COMPONENTS)
					list(APPEND PIL_NOTFOUND_COMPONENTS ${PIL_MODULE_NAME})
				else(PIL_FIND_COMPONENTS)
					message(STATUS "Can't found PIL module " ${PIL_MODULE_NAME})
				endif(PIL_FIND_COMPONENTS)
			endif(PI_${PIL_MODULE_NAME_UPPER}_LIBRARIES)

		endforeach()
	
		if(PIL_LIBRARIES)
			message( STATUS "Looking for PIL-${PIL_FIND_VERSION} or greater  - found ${PIL_VERSION}" )
			if(PIL_NOTFOUND_COMPONENTS)
				SET(PIL_FOUND 0)
				message(FATAL_ERROR "The following PIL modules are required but not found: ${PIL_NOTFOUND_COMPONENTS}")
			else(PIL_NOTFOUND_COMPONENTS)
				SET ( PIL_FOUND 1 )
			endif(PIL_NOTFOUND_COMPONENTS)
		else(PIL_LIBRARIES)
			message( STATUS "Looking for PIL-${PIL_FIND_VERSION} or greater  - found ${PIL_VERSION} but no library available." )
			SET ( PIL_FOUND 0 )
		endif()

	else(PIL_VERSION_OK)
			message( STATUS "Looking for PIL-${PIL_FIND_VERSION} or greater  - not found" )
			SET ( PIL_FOUND 0 )
	endif(PIL_VERSION_OK)
	
ENDIF(WIN32)
