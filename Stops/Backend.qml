import QtQuick 2.0

import "onebusaway.js" as OneBusAway
import "translink.js" as Translink
import "keys.js" as Keys

Item {
    property string backendId;

    property var backends: {
        "onebusaway": {"name": "OneBusAway (Puget Sound)", "module": OneBusAway, "key": Keys.OneBusAway},
        "translink": {"name": "Translink (Metro Vancouver)", "module": Translink, "key": Keys.Translink},
    };

    function listBackends()
    {
        var results = [];

        var keys = Object.keys(backends);
        for (var i = 0, len = keys.length; i < len; i++) {
            var backend = backends[keys[i]];
            results.push({"id": keys[i], "name": backend.name});
        }

        return results;
    }

    function getStopInfo(stopId, onCompleted) {
        var backend = backends[backendId];
        backend.module.getStopInfo(stopId, backend.key, onCompleted);
    }

    function getStopEstimates(stopId, onCompleted) {
        var backend = backends[backendId];
        backend.module.getStopEstimates(stopId, backend.key, onCompleted);
    }
}

