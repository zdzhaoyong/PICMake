file(GLOB APPS2BUILD "*")

foreach(APPNAME ${APPS2BUILD})
	if(IS_DIRECTORY ${APPNAME} AND EXISTS ${APPNAME}/CMakeLists.txt)
		add_subdirectory(${APPNAME})
	endif()
endforeach()
