import QtQuick 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Component {
    Dialog {
        id: settingsDialog
        title: "Select backend"
        property int defaultBackendIndex: 0;
        property var backends: backend.listBackends();

        ListModel {
            id: backendsModel
            Component.onCompleted: {
                for (var i = 0; i < backends.length; i++) {
                    var b = backends[i];
                    append(backends[i]);
                }
            }
        }

        OptionSelector {
            id: backendsSelector
            model: backendsModel
            delegate: Component {
                OptionSelectorDelegate {
                    text: name
                }
            }
        }

        Button {
            text: "Ok"
            color: UbuntuColors.orange
            onClicked: {
                var backendId = backendsModel.get(backendsSelector.selectedIndex).id;
                backendDocument.contents = { 'backend': backendId };
                PopupUtils.close(settingsDialog);
            }
        }
    }
}
