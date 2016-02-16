
SET( ZLIB_OLD_NAME libzlibstatic.a )
SET( ZLIB_NEW_NAME libz.a )

# Rename the library in the zlib library folder
FILE( RENAME ${ZLIB_LIBRARY_DIR}/${ZLIB_OLD_NAME} ${ZLIB_LIBRARY_DIR}/${ZLIB_NEW_NAME} )

# Rename the library in the main project library folder
FILE( RENAME ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${ZLIB_OLD_NAME} ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${ZLIB_NEW_NAME} )

SET( ZLIB_DLL_NAME libzlib.dll.a )

# Delete the dynamic link library so it doesn't get used by mistake
# FILE( REMOVE ${ZLIB_LIBRARY_DIR}/${ZLIB_DLL_NAME} )
# FILE( REMOVE ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${ZLIB_DLL_NAME} )