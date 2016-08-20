import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3
import U1db 1.0

/*
  The Stops MainView holds the resources that are common to all pages, including
  the database, backend object, and page stack.
*/
MainView {
    objectName: "stopsMain"

    applicationName: "stops.apaugh"

    width: units.gu(100)
    height: units.gu(75)

    Database {
            id: stopsDatabase
            path: "stopsDb"
    }

    Query {
        id: stopsDatabaseQuery
        index: Index {
            database: stopsDatabase
            expression: ['backendId', 'stopId', 'name', 'routes']
        }
        query: [backend.backendId, '*', '*', '*']
    }

    Document {
        id: backendDocument
        database: stopsDatabase
        docId: 'backend'
        defaults: { 'backend': 'onebusaway' }
        create: true
    }

    Backend {
        id: backend
        backendId: backendDocument.contents.backend
    }

    PageStack {
        id: mainStack
        anchors {
            fill: undefined
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        Component.onCompleted: {
            push(Qt.resolvedUrl("StopList.qml"));
        }
    }
}

