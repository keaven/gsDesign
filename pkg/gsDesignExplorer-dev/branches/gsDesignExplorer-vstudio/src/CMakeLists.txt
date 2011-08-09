cmake_minimum_required(VERSION 2.8.1)

#set( CMAKE_VERBOSE_MAKEFILE on )

project(gsDesignExplorer)

find_package( Qt4 4.0.0 COMPONENTS QtCore QtCored QtGui QtOpenGL QtHelp QtTest Qwt REQUIRED )

## Begin FindQwt.cmake from Thomas Moenicke
##
# - Try to find the Qwt includes and library
# which defines
#
# QWT_FOUND - system has Qwt
# QWT_INCLUDE_DIR - where to find qwt.h
# QWT_LIBRARIES - the libraries to link against to use Qwt
# QWT_LIBRARY - where to find the Qwt library (not for general use)

# copyright (c) 2006 Thomas Moenicke thomas.moenicke at kdemail.net
#
# Redistribution and use is allowed according to the terms of the BSD license.

IF(NOT QT4_FOUND)
    INCLUDE(FindQt4)
ENDIF(NOT QT4_FOUND)

SET(QWT_FOUND "NO")

IF(QT4_FOUND)
    FIND_PATH(QWT_INCLUDE_DIR qwt.h
    /usr/local/qwt/include
    /usr/local/include
    /usr/include/qwt
    /usr/include
    c:/Qwt-5.3.0-svn/include
    c:/Qwt-5.2.2-svn/include
    c:/Qwt/include
    c:/Qwt-6.0.1-svn/include
	c:/dev/libs/qwt/qwt-6.0/src
    )

    SET(QWT_NAMES ${QWT_NAMES} qwtd5 qwt libqwt)
    SET(QWT_DLL_NAMES ${QWT_DLL_NAMES} qwtd5.dll qwt.dll)
    FIND_LIBRARY(QWT_LIBRARY
        NAMES ${QWT_NAMES}
        PATHS /usr/local/qwt/lib /usr/local/lib /usr/lib c:/Qwt-5.3.0-svn/lib c:/Qwt-5.2.2-svn/lib c:/Qwt/lib c:/Qwt-6.0.1-svn/lib c:/dev/libs/qwt/qwt-6.0/lib
    )
    FIND_FILE(QWT_DLL
        NAMES ${QWT_DLL_NAMES}
        PATHS c:/Qwt-5.3.0-svn/lib c:/Qwt-5.2.2-svn/lib c:/Qwt/lib c:/Qwt-6.0.1-svn/lib c:/dev/libs/qwt/qwt-6.0/lib
    )
    FIND_FILE(QTCOREd4_DLL
        NAMES QtCored4.dll
        PATHS C:/QtSDK/Desktop/Qt/4.7.3/mingw/lib C:/dev/tools/QtSDK/Desktop/Qt/4.7.3/mingw/lib
    )

    IF (QWT_LIBRARY)

        SET(QWT_LIBRARIES ${QWT_LIBRARY})
        SET(QWT_FOUND "YES")

        IF (CYGWIN)
            IF(BUILD_SHARED_LIBS)
            # No need to define QWT_USE_DLL here, because it's default for Cygwin.
            ELSE(BUILD_SHARED_LIBS)
            SET (QWT_DEFINITIONS -DQWT_STATIC)
            ENDIF(BUILD_SHARED_LIBS)
        ENDIF (CYGWIN)

    ENDIF (QWT_LIBRARY)
ENDIF(QT4_FOUND)

IF (QWT_FOUND)
  IF (NOT QWT_FIND_QUIETLY)
    MESSAGE(STATUS "Found Qwt: ${QWT_LIBRARY}")
  ENDIF (NOT QWT_FIND_QUIETLY)
ELSE (QWT_FOUND)
  IF (QWT_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find Qwt library")
  ENDIF (QWT_FIND_REQUIRED)
ENDIF (QWT_FOUND)

MARK_AS_ADVANCED(QWT_INCLUDE_DIR QWT_LIBRARY)

## End FindQwt.cmake from Thomas Moenicke

include(${QT_USE_FILE})

include_directories( ./ ${R_INCLUDES} ../explorergui-build/ ${QWT_INCLUDE_DIR} )

set( gsDesignExplorer_LIB_SRCS gsdesign.cpp gsDesignGUI.cpp gsDesignTips.cpp GsRList.cpp main.cpp Rcpp.cpp )

set( gsDesignExplorer_MOC_SRCS gsdesign.cpp )

set( gsDesignExplorer_MOC_HDRS gsdesign.h )

set( gsDesignExplorer_UIS gsdesign.ui )

set( gsDesignExplorer_RCS images.qrc )

QT4_ADD_RESOURCES( gsDesignExplorer_RC_SRCS ${gsDesignExplorer_RCS} )

QT4_WRAP_UI( gsDesignExplorer_UI_HDRS ${gsDesignExplorer_UIS} )

QT4_WRAP_CPP( gsDesignExplorer_MOC_FILES ${gsDesignExplorer_MOC_HDRS} )

set( CMAKE_EXE_LINKER_FLAGS "-Wl,-E")

if(WIN32) # Toughest Win32 part: generating the defs file for the DLL
set( CMAKE_SHARED_LINKER_FLAGS "-Wl,--enable-auto-import -Wl,--export-all-symbols -Wl,--add-stdcall-alias" )
set( CMAKE_EXE_LINKER_FLAGS "-Wl,-E -Wl,--shared-libgcc -Wl,--enable-auto-import -Wl,--export-all-symbols -Wl,--add-stdcall-alias")
foreach(gsDesignExplorer_lib_src ${gsDesignExplorer_LIB_SRCS})
  list(APPEND gsDesignExplorer_LIB_OBJS "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/gsDesignExplorer.dir/${gsDesignExplorer_lib_src}${CMAKE_CXX_OUTPUT_EXTENSION}")
endforeach(gsDesignExplorer_lib_src ${gsDesignExplorer_LIB_SRCS})
add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/gsDesignExplorer.def 
                   COMMAND sh ARGS ${CMAKE_CURRENT_SOURCE_DIR}/mkdef.sh
                   DEPENDS ${gsDesignExplorer_LIB_OBJS}) 
SET(CMAKE_LINK_DEF_FILE_FLAG "gsDesignExplorer.def ") # space needs to be there
add_library(gsDesignExplorer SHARED gsDesignExplorer.def ${gsDesignExplorer_LIB_SRCS} ${gsDesignExplorer_MOC_FILES} ${gsDesignExplorer_RC_SRCS} ${gsDesignExplorer_UI_HDRS} )
set_target_properties(gsDesignExplorer PROPERTIES COMPILE_FLAGS "-pipe -O2 -Wall -W -D_REENTRANT -DGSDESIGNGUI_EXPORTS -DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -DQT_SHARED")
target_link_libraries(gsDesignExplorer ${QT_LIBRARIES} ${QWT_LIBRARIES} ${R_LIBRARIES})
else(WIN32)
add_library(gsDesignExplorer SHARED ${gsDesignExplorer_LIB_SRCS} ${gsDesignExplorer_MOC_FILES} ${gsDesignExplorer_RC_SRCS} ${gsDesignExplorer_UI_HDRS} )
set_target_properties(gsDesignExplorer PROPERTIES COMPILE_FLAGS "-m64 -pipe -O2 -Wall -W -D_REENTRANT -fPIC -DGSDESIGNGUI_EXPORTS -DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -DQT_SHARED")
target_link_libraries(gsDesignExplorer ${QT_LIBRARIES} ${QWT_LIBRARIES} ${R_LIBRARIES})
endif(WIN32)

if(NOT WIN32) # Need to force .so on Mac, but Windows needs to be .dll
set_target_properties(gsDesignExplorer PROPERTIES PREFIX "lib")
set_target_properties(gsDesignExplorer PROPERTIES SUFFIX ".so")
install(TARGETS gsDesignExplorer LIBRARY DESTINATION . )
else(NOT WIN32)
set_target_properties(gsDesignExplorer PROPERTIES PREFIX "lib")
install(TARGETS gsDesignExplorer RUNTIME DESTINATION . )
install(FILES ${QWT_DLL} DESTINATION . )
#install(FILES ${QTCORED4_DLL} DESTINATION . )
install(DIRECTORY ${QT_BINARY_DIR} DESTINATION .
        FILES_MATCHING 
        PATTERN "*.dll")
endif(NOT WIN32)
