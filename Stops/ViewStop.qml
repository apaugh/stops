import QtQuick 2.4
import QtQuick.Layouts 1.0
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3

/*
    The view stop page lists all the arriving buses for the selected stop and their times.
*/
Page {
    id: viewStopPage
    property string stopNumber: ""

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("View Stop")

        StyleHints {
            foregroundColor: UbuntuColors.orange
            backgroundColor: UbuntuColors.porcelain
            dividerColor: UbuntuColors.slate
        }

        leadingActionBar {
            actions:  Action {
                iconName: "back"
                text: i18n.tr("Back.")
                onTriggered: {
                    mainStack.pop();
                }
            }
        }
    }

    Item {
        anchors.fill: parent

        ActivityIndicator {
            id: loadingIndicator
            running: true
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
        }
    }

    UbuntuListView {
        id: stopListView
        anchors {
            top: pageHeader.bottom
            bottom: viewStopPage.bottom
        }
        width: viewStopPage.width
        visible: false

        model: ListModel {
            id: stopListModel
            Component.onCompleted: {
                backend.getStopEstimates(viewStopPage.stopNumber, function(buses) {
                    for(var i = 0, len = buses.length; i < len; i++) {
                        stopListModel.append(buses[i]);
                    }
                    loadingIndicator.running = false;
                    stopListView.visible = true;
                });
            }
        }

        delegate: ListItem {
            id: stopListItem

            Label {
                id: minutesLabel
                height: parent.height
                text: minutes
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.VerticalFit
                fontSize: "x-large"
                anchors {
                    left: parent.left
                    leftMargin: units.gu(1)
                }
            }

            Label {
                id: minsConstLabel
                height: parent.height
                text: "min"
                fontSizeMode: Text.VerticalFit
                fontSize: "medium"
                anchors {
                    left: minutesLabel.right
                    baseline: minutesLabel.baseline
                }
            }

            Label {
                id: routeNameLabel
                text: route
                fontSize: "large"
                anchors {
                    left: parent.left
                    leftMargin: units.gu(12)
                    top: parent.top
                    topMargin: units.gu(0.5)
                    bottom: parent.bottom
                }
            }
            Label {
                id: destinationLabel
                text: name
                height: parent.height
                fontSize: "medium"
                anchors {
                    left: parent.left
                    leftMargin: units.gu(12)
                    baseline: parent.bottom
                    baselineOffset: units.gu(-1.5)
                }
            }
        }
    }

}
