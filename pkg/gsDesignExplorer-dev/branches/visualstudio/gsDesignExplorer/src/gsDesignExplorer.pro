# -------------------------------------------------
# Project created by QtCreator 2009-11-20T14:03:21
# -------------------------------------------------
TARGET = gsDesignExplorer
TEMPLATE = lib
SOURCES += main.cpp \
    gsdesign.cpp \
    Rcpp.cpp \
    GsRList.cpp \
    gsDesignTips.cpp \
    gsDesignGUI.cpp
HEADERS += gsdesign.h \
    ui_gsdesign.h \
    Rcpp.hpp \
    GsRList.h \
    gsDesignGUI.h
FORMS += gsdesign.ui
RESOURCES += images.qrc
DEFINES += GSDESIGNGUI_EXPORTS

# -------------------------------------------------
# Uncomment the appropriate section below, and modify
# the paths as appropriate to point to the R include
# directory and the R shared library. Only uncomment
# the lines with actual statements (DEFINES, INCLUDEPATH,
# LIBS).
# -------------------------------------------------
win32{
    INCLUDEPATH += "C:\dev\tools\R\R-2.13.1\include"
    LIBS += "C:\dev\tools\R\R-2.13.1\bin\i386\R.lib"
}
#
#macx {
#    INCLUDEPATH += /Library/Frameworks/R.framework/Resources/include
#    LIBS += /Library/Frameworks/R.framework/Resources/lib/libR.dylib
#}
#
#unix{
#    INCLUDEPATH += /opt/REvolution/R-2.9.2/include
#    LIBS += /opt/REvolution/R-2.9.2/lib
#}

