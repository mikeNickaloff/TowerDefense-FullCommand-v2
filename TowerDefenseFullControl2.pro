TEMPLATE = app

QT += qml quick widgets


SOURCES += main.cpp \
    src_game/game.cpp \
    src_game/team.cpp \
    src_game/player.cpp \
    src_game/map.cpp \
    src_ui/towerchooser.cpp \
    src_ui/towerinfo.cpp \
    src_ui/towerupgrademenu.cpp \
    src_elements/board.cpp \
    src_elements/square.cpp \
    src_elements/gun.cpp \
    src_elements/wall.cpp \
    src_elements/start.cpp \
    src_elements/end.cpp \
    src_elements/attacker.cpp \
    src_elements/projectile.cpp \
    src_ui/scorehud.cpp \
    src_ui/gameconfigmenu.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    src_game/game.h \
    src_game/team.h \
    src_game/player.h \
    src_game/map.h \
    src_ui/towerchooser.h \
    src_ui/towerinfo.h \
    src_ui/towerupgrademenu.h \
    src_elements/board.h \
    src_elements/square.h \
    src_elements/gun.h \
    src_elements/wall.h \
    src_elements/start.h \
    src_elements/end.h \
    src_elements/attacker.h \
    src_elements/projectile.h \
    src_ui/scorehud.h \
    src_ui/gameconfigmenu.h

DISTFILES += \
    src_qml/SquareVisual.qml \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
