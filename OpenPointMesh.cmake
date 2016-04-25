#### Sanity Checks ####
INCLUDE( PreventInSourceBuilds )
INCLUDE( PreventInBuildInstalls )

# Tell CMake where our built libraries are located
SET( CMAKE_PREFIX_PATH
	${BOOST_DIR}
	${BZIP2_DIR}
	${EIGEN_DIR}
	${EXPAT_DIR}
	${FLANN_DIR}
	${FONTCONFIG_DIR}
	${FREETYPE_DIR}
	${JPEG_DIR}
	${LCMS_DIR}
	${LIBTOOL_DIR}
	${LIBUSB_1_DIR}
	${MNG_DIR}
	${OPENNI2_DIR}
	${PCL_DIR}
	${PNG_DIR}
	${QHULL_DIR}
	${QT_DIR}
	${TIFF_DIR}
	${VTK_DIR}
	${ZLIB_DIR}
)

#### Package Dependencies ####
FIND_PACKAGE( Qt4 REQUIRED )
FIND_PACKAGE( VTK REQUIRED )
FIND_PACKAGE( PCL 1.7 REQUIRED )
FIND_PACKAGE( GLUT REQUIRED )
FIND_PACKAGE( OpenGL REQUIRED )
INCLUDE( ExternalProject )

#### Variables ####
FILE( GLOB OPENPOINTMESH_HEADERS "include/*.h" )
FILE( GLOB OPENPOINTMESH_SOURCES "src/*.cpp" )
FILE( GLOB OPENPOINTMESH_FORMS "src/*.ui" )
SET( OPENPOINTMESH_INCLUDE_DIRS "include" )
SET( OPENPOINTMESH_BUILD_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/build/build_output" )
SET( VTK_LIBRARIES vtkRendering vtkGraphics vtkHybrid QVTK )

#### Download OpenNI2 source, we use it for the viewer ####
# Download the OpenNI2 Source Code
SET( OPENNI2_SOURCE_ZIP ${CMAKE_CURRENT_BINARY_DIR}/v2.2.0-debian.tar.gz )
SET( OPENNI2_SOURCE_URL https://github.com/occipital/OpenNI2/archive/v2.2.0-debian.tar.gz )
SET( OPENNI2_SOURCE_MD5 bdb95be379150c6bd0433f8a6862ee7f )

FILE( DOWNLOAD ${OPENNI2_SOURCE_URL} ${OPENNI2_SOURCE_ZIP}
		EXPECTED_MD5 ${OPENNI2_SOURCE_MD5}
		SHOW_PROGRESS )

# Unzip the sources
SET( OPENNI2_SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/OpenNI2-2.2.0-debian )
FILE( MAKE_DIRECTORY ${OPENNI2_SOURCE_DIR} )
EXECUTE_PROCESS( COMMAND ${CMAKE_COMMAND} -E tar xzf ${OPENNI2_SOURCE_ZIP} )

# Viewer Sources
SET( NIVIEWER_INCLUDE_DIRS 	${OPENNI2_SOURCE_DIR}/Source/Tools/NiViewer
							${OPENNI2_SOURCE_DIR}/Include
							${OPENNI2_SOURCE_DIR}/ThirdParty/PSCommon/XnLib/Include
							${OPENNI2_SOURCE_DIR}/ThirdParty/GL/ )

SET( NIVIEWER_SOURCE_DIR ${OPENNI2_SOURCE_DIR}/Source/Tools/NiViewer )
SET( NIVIEWER_SOURCES 	${NIVIEWER_SOURCE_DIR}/Device.cpp
						${NIVIEWER_SOURCE_DIR}/Draw.cpp
						${NIVIEWER_SOURCE_DIR}/Keyboard.cpp
						${NIVIEWER_SOURCE_DIR}/Menu.cpp
						${NIVIEWER_SOURCE_DIR}/MouseInput.cpp
						${NIVIEWER_SOURCE_DIR}/Capture.cpp )

#### Qt4 Settings ####
INCLUDE( ${QT_USE_FILE} )
QT4_WRAP_CPP( OPENPOINTMESH_HEADERS_MOC ${OPENPOINTMESH_HEADERS} )
QT4_WRAP_UI( OPENPOINTMESH_FORMS_HEADERS ${OPENPOINTMESH_FORMS} )

#### Platform Specific Build Flags ####
IF( UNIX )
	MESSAGE( STATUS "Setting GCC flags" )
	SET( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DUNIX -DGLX_GLXEXT_LEGACY -fexceptions -g -Wall" )
ELSE ()
	MESSAGE( FATAL_ERROR "You are on an unsupported platform! (Not UNIX)" )
ENDIF()
MESSAGE( STATUS "** CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}" )

#### Build Settings ####
SET( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${OPENPOINTMESH_BUILD_OUTPUT_DIRECTORY} )
SET( CMAKE_LIBRARIES_OUTPUT_DIRECTORY ${OPENPOINTMESH_BUILD_OUTPUT_DIRECTORY} )

INCLUDE_DIRECTORIES(	${OPENPOINTMESH_INCLUDE_DIRS}
						${PCL_INCLUDE_DIRS}
						${NIVIEWER_INCLUDE_DIRS} )

LINK_DIRECTORIES( ${PCL_LIBRARY_DIRS} )

ADD_DEFINITIONS(	${PCL_DEFINITIONS}
					${QT_DEFINITIONS} )

ADD_EXECUTABLE(	${PROJECT_NAME}
				${OPENPOINTMESH_SOURCES}
				${OPENPOINTMESH_FORMS_HEADERS}
				${OPENPOINTMESH_HEADERS_MOC}
				${NIVIEWER_SOURCES} )

target_link_libraries(	${PROJECT_NAME}
						${PCL_LIBRARIES}
						${QT_LIBRARIES}
						${VTK_LIBRARIES}
						${OPENGL_LIBRARIES}
						${GLUT_glut_LIBRARY} )
