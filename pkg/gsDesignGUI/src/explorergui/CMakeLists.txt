cmake_minimum_required(VERSION 2.8.1)

#set( CMAKE_VERBOSE_MAKEFILE on )

project(gsdesigngui)

find_package( Qt4 4.0.0 COMPONENTS QtCore QtGui QtOpenGL QtHelp QtTest REQUIRED )

include(${QT_USE_FILE})

include_directories( ./ ${R_INCLUDES} ../../explorergui-build/ )

set( gsdesigngui_LIB_SRCS gsdesign.cpp gsDesignGUI.cpp gsDesignTips.cpp GsRList.cpp main.cpp Rcpp.cpp qdslider.cpp )

set( gsdesigngui_MOC_SRCS gsdesign.cpp )

set( gsdesigngui_MOC_HDRS gsdesign.h qdslider.h )

set( gsdesigngui_UIS gsdesign.ui )

set( gsdesigngui_RCS images.qrc )

QT4_ADD_RESOURCES( gsdesigngui_RC_SRCS ${gsdesigngui_RCS} )

QT4_WRAP_UI( gsdesigngui_UI_HDRS ${gsdesigngui_UIS} )

QT4_WRAP_CPP( gsdesigngui_MOC_FILES ${gsdesigngui_MOC_HDRS} )

if(WIN32) # Toughest Win32 part: generating the defs file for the DLL
foreach(gsdesigngui_lib_src ${gsdesigngui_LIB_SRCS})
  list(APPEND gsdesigngui_LIB_OBJS "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/gsdesigngui.dir/${gsdesigngui_lib_src}${CMAKE_CXX_OUTPUT_EXTENSION}")
endforeach(gsdesigngui_lib_src ${gsdesigngui_LIB_SRCS})
add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/gsdesigngui.def 
                   COMMAND sh ARGS ${CMAKE_CURRENT_SOURCE_DIR}/mkdef.sh
                   DEPENDS ${gsdesigngui_LIB_OBJS}) 
SET(CMAKE_LINK_DEF_FILE_FLAG "gsdesigngui.def ") # space needs to be there
add_library(gsdesigngui SHARED gsdesigngui.def ${gsdesigngui_LIB_SRCS} ${gsdesigngui_MOC_FILES} ${gsdesigngui_RC_SRCS} ${gsdesigngui_UI_HDRS} )
set_target_properties(gsdesigngui PROPERTIES COMPILE_FLAGS "-pipe -O2 -Wall -W -D_REENTRANT -DGSDESIGNGUI_EXPORTS -DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -DQT_SHARED")
target_link_libraries(gsdesigngui ${QT_LIBRARIES} ${R_LIBRARIES})
else(WIN32)
add_library(gsdesigngui SHARED ${gsdesigngui_LIB_SRCS} ${gsdesigngui_MOC_FILES} ${gsdesigngui_RC_SRCS} ${gsdesigngui_UI_HDRS} )
set_target_properties(gsdesigngui PROPERTIES COMPILE_FLAGS "-m64 -pipe -O2 -Wall -W -D_REENTRANT -fPIC -DGSDESIGNGUI_EXPORTS -DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -DQT_SHARED")
target_link_libraries(gsdesigngui ${QT_LIBRARIES})
endif(WIN32)

if(NOT WIN32) # Need to force .so on Mac, but Windows needs to be .dll
set_target_properties(gsdesigngui PROPERTIES PREFIX "lib")
set_target_properties(gsdesigngui PROPERTIES SUFFIX ".so")
install(TARGETS gsdesigngui LIBRARY DESTINATION . )
else(NOT WIN32)
set_target_properties(gsdesigngui PROPERTIES PREFIX "lib")
install(TARGETS gsdesigngui RUNTIME DESTINATION . )
install(DIRECTORY ${QT_BINARY_DIR} DESTINATION ../../../inst/libs/i386
        FILES_MATCHING 
        PATTERN "*d4.dll" EXCLUDE
        PATTERN "*.dll")
endif(NOT WIN32)
