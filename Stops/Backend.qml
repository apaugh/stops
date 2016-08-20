import QtQuick 2.0

import "onebusaway.js" as OneBusAway
import "translink.js" as Translink
import "keys.js" as Keys

/*
  The backends item stores a list of available backends and tracks the currently selected backend.
  The getStopInfo and getStopEstimates methods call into the js module provided by the current backend.
*/
Item {

    // The currently selected backend id.
    property string backendId;

    // Dictionary of available backends by backend id.
    property var backends: {
        "onebusaway": {"name": "OneBusAway (Puget Sound)", "module": OneBusAway, "key": Keys.OneBusAway},
        "translink": {"name": "Translink (Metro Vancouver)", "module": Translink, "key": Keys.Translink},
    };

    /*
      Provides a list of available backends. This is used when selecting a backend.
      Note: The first item in the list is always the currently selected backend.
    */
    function listBackends()
    {
        var results = [{"id": backendId, "name": backends[backendId].name}];

        var keys = Object.keys(backends);
        for (var i = 0, len = keys.length; i < len; i++) {
            if (keys[i] != backendId)
            {
                var backend = backends[keys[i]];
                results.push({"id": keys[i], "name": backend.name});
            }
        }

        return results;
    }

    // Gets stop info for a given stop id, including name and buses.
    function getStopInfo(stopId, onCompleted) {
        var backend = backends[backendId];
        backend.module.getStopInfo(stopId, backend.key, onCompleted);
    }

    // Gets stop estimates for a given stop id. This is a list of bus arrivals and their times.
    function getStopEstimates(stopId, onCompleted) {
        var backend = backends[backendId];
        backend.module.getStopEstimates(stopId, backend.key, onCompleted);
    }
}

