cmake_minimum_required(VERSION 2.8.1)

project(gsDesignExplorer)

#set(CMAKE_VERBOSE_MAKEFILE ON)

find_package( Qt4 4.0.0 COMPONENTS QtCore QtGui QtOpenGL QtHelp QtTest REQUIRED )

include(${QT_USE_FILE})

#add_subdirectory( ./explorergui )

include_directories( ./ ${R_INCLUDES} )

link_directories( ../inst/libs )

set( gsDesignExplorer_LIB_SRCS gsDesignGUI.c )

if(WIN32) # Toughest Win32 part: generating the defs file for the DLL
foreach(gsDesignExplorer_lib_src ${gsDesignExplorer_LIB_SRCS})
  list(APPEND gsDesignExplorer_LIB_OBJS "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/gsDesignExplorer.dir/${gsDesignExplorer_lib_src}${CMAKE_CXX_OUTPUT_EXTENSION}")
endforeach(gsDesignExplorer_lib_src ${gsDesignExplorer_LIB_SRCS})
add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/gsDesignExplorer.def 
                   COMMAND sh ARGS ${CMAKE_CURRENT_SOURCE_DIR}/mkdef.sh
                   DEPENDS ${gsDesignExplorer_LIB_OBJS}) 
SET(CMAKE_LINK_DEF_FILE_FLAG "gsDesignExplorer.def ") # space needs to be there
add_library(gsDesignExplorer SHARED gsDesignExplorer.def ${gsDesignExplorer_LIB_SRCS} ${gsDesignExplorer_MOC_FILES})
else(WIN32)
add_library(gsDesignExplorer SHARED ${gsDesignExplorer_LIB_SRCS} ${gsDesignExplorer_MOC_FILES})
endif(WIN32)

set_target_properties(gsDesignExplorer PROPERTIES COMPILE_FLAGS "-ggdb")

target_link_libraries(gsDesignExplorer gsdesigngui ${QT_LIBRARIES} ${R_LIBRARIES})

if(NOT WIN32) # Need to force .so on Mac, but Windows needs to be .dll
set_target_properties(gsDesignExplorer PROPERTIES PREFIX "lib")
set_target_properties( gsDesignExplorer PROPERTIES SUFFIX ".so" )
install(TARGETS gsDesignExplorer LIBRARY DESTINATION . )
else(NOT WIN32)
set_target_properties(gsDesignExplorer PROPERTIES PREFIX "lib")
install(TARGETS gsDesignExplorer RUNTIME DESTINATION . )
install(DIRECTORY ${QT_BINARY_DIR} DESTINATION ../inst
        FILES_MATCHING 
        PATTERN "*d4.dll" EXCLUDE
        PATTERN "*.dll")
endif(NOT WIN32)


