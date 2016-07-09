import QtQuick 2.4
import QtQuick.Layouts 1.0
import Ubuntu.Components 1.3
import U1db 1.0

Page {
    id: addStopPage

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Add Stop")

        StyleHints {
            foregroundColor: UbuntuColors.orange
            backgroundColor: UbuntuColors.porcelain
            dividerColor: UbuntuColors.slate
        }
    }

    function acceptInput() {
        Qt.inputMethod.commit();
        Qt.inputMethod.hide();

        var stopId = searchField.text;
        if (stopId != "") {
            loadingIndicator.running = true;
            notFoundIndicator.visible = false;

            backend.getStopInfo(stopId, function(result) {
                loadingIndicator.running = false;
                if (result !== null) {
                    var newDocument = { "backendId": backend.backendId, "stopId": stopId, "name": result.name, "routes": result.routes };
                    stopsDatabase.putDoc(newDocument, backend.backendId + "_" + stopId);
                    mainStack.pop();
                }
                else {
                    notFoundIndicator.visible = true;
                }
            });
        }
    }

    Rectangle {
        id: bottomContainer

        anchors.top: pageHeader.bottom
        anchors.topMargin: units.gu(10)
        width: parent.width

        color: "white"

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: units.dp(8)

            Row {
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    id: notFoundIndicator
                    text: "Stop not found."
                    color: "red"
                    fontSize: "large"
                    visible: false
                }

                ActivityIndicator {
                    id: loadingIndicator
                    running: false
                }
            }

            Row {
                spacing: units.dp(8)
                anchors.horizontalCenter: parent.horizontalCenter

                TextField {
                    id: searchField
                    onAccepted: acceptInput()
                    width: units.gu(40)
                    height: units.gu(10)
                    horizontalAlignment: TextInput.AlignHCenter
                    font.pixelSize: 60
                    maximumLength: 5
                }

                Icon {
                    id: searchButton
                    name: "add"
                    width: height
                    height: searchField.height
                    color: UbuntuColors.orange

                    MouseArea {
                        anchors.fill: parent
                        onClicked: acceptInput()
                    }
                }
            }
        }
    }
}
