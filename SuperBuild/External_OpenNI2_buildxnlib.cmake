
# Set directories
SET( XNLIB_SOURCE_DIR ${SOURCE_DIR}/ThirdParty/PSCommon/XnLib/Source )

# Set compile and link flags
SET( XNLIB_CXX_FLAGS "${EP_NONCMAKE_COMMON_CXX_FLAGS} -I${XNLIB_INCLUDE_DIR} -I${LIBUSB_1_INCLUDE_DIR}" )
SET( XNLIB_LD_FLAGS "${CMAKE_EXE_LINKER_CXX_FLAGS} -L${LIBUSB_1_LIBRARY_DIR}" )

# Add flags for Position Independent Code
IF( CMAKE_POSITION_INDEPENDENT_CODE )
	SET( XNLIB_CXX_FLAGS "${XNLIB_CXX_FLAGS} -fPIC" )
ENDIF()

# Create the build command arguments list
SET( XNLIB_BUILD_ARGS CFLAGS=${XNLIB_CXX_FLAGS} LDFLAGS=${XNLIB_LD_FLAGS} ALLOW_WARNINGS=1 )

# Select Shared or Static Libraries
IF( BUILD_SHARED_LIBS )
	LIST( APPEND XNLIB_BUILD_ARGS LIB_NAME=${LIBRARY_NAME} )
ELSE()
	LIST( APPEND XNLIB_BUILD_ARGS SLIB_NAME=${LIBRARY_NAME} )
ENDIF()

# If needed set debug information
IF( CMAKE_BUILD_TYPE MATCHES "Debug" )
	LIST( APPEND XNLIB_BUILD_ARGS CFG=Debug )
	SET( XNLIB_BIN_DIR ${SOURCE_DIR}/ThirdParty/PSCommon/XnLib/Bin/x64-Debug )
ENDIF()

# Run the build command
EXECUTE_PROCESS( COMMAND make ${XNLIB_BUILD_ARGS}
					WORKING_DIRECTORY ${XNLIB_SOURCE_DIR} RESULT_VARIABLE build_result
)

IF( NOT "${build_result}" STREQUAL "0" )
	MESSAGE( STATUS "build XnLib Failed!!!" )
	MESSAGE( FATAL_ERROR "build_result='${build_result}'" )
ENDIF()



RETURN( ${install_result} )