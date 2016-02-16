
IF( WIN32 )
	SET( QT_BUILD_COMMAND
		mingw32-make
	)
ELSE()
	SET( QT_BUILD_COMMAND
		make
	)
ENDIF()

EXECUTE_PROCESS( COMMAND ${QT_BUILD_COMMAND}
		WORKING_DIRECTORY ${BUILD_DIR} RESULT_VARIABLE build_result )

RETURN( ${build_result} )