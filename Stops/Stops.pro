TEMPLATE = aux
TARGET = Stops

RESOURCES += Stops.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  Stops.apparmor \
               Stops.png

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)               

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               Stops.desktop

#specify where the qml/js files are installed to
qml_files.path = /Stops
qml_files.files += $${QML_FILES}

#specify where the config files are installed to
config_files.path = /Stops
config_files.files += $${CONF_FILES}

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /Stops
desktop_file.files = $$OUT_PWD/Stops.desktop
desktop_file.CONFIG += no_check_exist

INSTALLS+=config_files qml_files desktop_file

DISTFILES += \
    AddStop.qml \
    StopList.qml \
    ViewStop.qml \
    backends/translink.js \
    backends/onebusaway.js \
    backends/keys.js \
    Settings.qml \
    Backend.qml

