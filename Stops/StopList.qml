import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3
import Ubuntu.Components.Popups 1.3
import U1db 1.0

/*
  The stop list page lists all the added stops by name and bus number(s).
*/
Page {
    id: stopListPage

    Settings {
        id: settingsDialog
    }

    AddStopPopup {
        id: addStopPopup
    }

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Stops")

        StyleHints {
            foregroundColor: UbuntuColors.orange
            backgroundColor: UbuntuColors.porcelain
            dividerColor: UbuntuColors.slate
        }

        trailingActionBar {
            actions:  [
                Action {
                    iconName: "add"
                    text: i18n.tr("Add stop")
                    onTriggered: {
                        PopupUtils.open(addStopPopup)
                    }
                },
                Action {
                    iconName: "settings"
                    text: i18n.tr("Change backend")
                    onTriggered: {
                        PopupUtils.open(settingsDialog)
                    }
                }
            ]}
    }

    Label {
        anchors.centerIn: parent
        fontSize: "x-large"
        wrapMode: Text.WordWrap
        width: parent.width - units.gu(5)
        horizontalAlignment: Text.AlignHCenter
        text: "Welcome to Stops!\n\nTo add a new stop, tap the + icon on the top right.\n\nTo change your backend, tap the settings icon on the top right."
        visible: stopsListView.count <= 0
    }

    UbuntuListView {
        id: stopsListView
        model: stopsDatabaseQuery
        width: stopListPage.width

        anchors {
            top: pageHeader.bottom
            bottom: stopListPage.bottom
            horizontalCenter: parent.horizontalCenter
        }
        delegate: ListItem {
            Label {
                id: stopNameLabel
                text: contents.name + " (" + contents.stopId + ")"
                fontSize: "large"
                anchors {
                    left: parent.left
                    leftMargin: units.gu(1)
                    top: parent.top
                    topMargin: units.gu(0.5)
                    bottom: parent.bottom
                }
            }
            Label {
                text: contents.routes
                height: parent.height
                fontSize: "medium"
                anchors {
                    left: parent.left
                    baseline: parent.bottom
                    baselineOffset: units.gu(-1.5)
                    leftMargin: units.gu(1)
                }
            }
            onClicked: {
                mainStack.push(Qt.resolvedUrl("ViewStop.qml"), {"stopNumber": contents.stopId });
            }
            leadingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "delete"
                        onTriggered: {
                            stopsDatabase.deleteDoc(docId);
                        }
                    }
                ]
            }
        }
    }
}
