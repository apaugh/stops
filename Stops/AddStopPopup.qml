import QtQuick 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

/*
  The add stop popup is a dialog used in the popup for adding a new stop.
*/
Component {
    Dialog {
        id: addStopDialog
        title: "Add a stop"

        function acceptInput() {
            Qt.inputMethod.commit();
            Qt.inputMethod.hide();

            var stopId = searchField.text;
            if (stopId != "") {
                loadingIndicator.running = true;
                notFoundIndicator.visible = false;
                addStopButton.visible = false;

                backend.getStopInfo(stopId, function(result) {
                    if (result !== null) {
                        var newDocument = { "backendId": backend.backendId, "stopId": stopId, "name": result.name, "routes": result.routes };
                        stopsDatabase.putDoc(newDocument, backend.backendId + "_" + stopId);
                        PopupUtils.close(addStopDialog);
                    }
                    else {
                        notFoundIndicator.visible = true;
                        searchField.errorHighlight = true;
                    }
                    loadingIndicator.running = false;
                    addStopButton.visible = true;
                });
            }
        }

        TextField {
            id: searchField
            onAccepted: acceptInput()
            horizontalAlignment: TextInput.AlignHCenter
            maximumLength: 5
            inputMethodHints: Qt.ImhDigitsOnly
            placeholderText: "Enter a stop number."
        }

        Label {
            id: notFoundIndicator
            text: "Stop not found."
            color: "red"
            fontSize: "medium"
            horizontalAlignment: Text.AlignHCenter
            visible: false
        }

        Button {
            id: addStopButton
            text: "Add Stop"
            color: UbuntuColors.orange
            onClicked: acceptInput()
        }

        ActivityIndicator {
            id: loadingIndicator
            running: false
            visible: running
        }

        Button {
            id: cancelButton
            text: "Cancel"
            color: UbuntuColors.red
            onClicked: PopupUtils.close(addStopDialog)
        }
    }
}
