#-------------------------------------------------
#
# Project created by QtCreator 2016-02-25T18:56:34
#
#-------------------------------------------------

QT       += testlib qml

TARGET = viewstacktests
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

SOURCES +=     main.cpp    

DEFINES += SRCDIR=\\\"$$PWD/\\\"

include(vendor/vendor.pri)
include(../../viewstack.pri)
DISTFILES +=     qpm.json \    
    qmltests/tst_Patch.qml

HEADERS +=    

write_file(qmlimport.path, QML_IMPORT_PATH)
