.pragma library

function getStopInfo(stopNumber, apiKey, onComplete) {
    var request = new XMLHttpRequest();
    var url = "http://api.pugetsound.onebusaway.org/api/where/stop/1_" + stopNumber + ".json?key=" + apiKey
    request.open("GET", url, true);
    request.setRequestHeader("Content-Type", "application/json");

    request.onreadystatechange = function() {
        if (request.readyState === XMLHttpRequest.DONE) {
            var responseData = JSON.parse(request.responseText);

            if (responseData.code !== 200) {
                onComplete(null);
		// Just some more comments
                return false;
            }

            var routes = [];

            var responseRoutes = responseData.data.references.routes;

            for(var i = 0, len = responseRoutes.length; i < len; i++)
            {
                routes.push(responseRoutes[i].shortName);
		    //Testing
            }

            var result = {
                name: responseData.data.entry.name,
                routes: routes.join(", ")
            }

            onComplete(result);
        }
    }

    request.send();
    return true;
}

function getStopEstimates(stopNumber, apiKey, onComplete) {
    var request = new XMLHttpRequest();
    var url = "http://api.pugetsound.onebusaway.org/api/where/arrivals-and-departures-for-stop/1_" + stopNumber + ".json?minutesBefore=0&minutesAfter=120&key=" + apiKey
    request.open("GET", url, true);
    request.setRequestHeader("Content-Type", "application/json");

    request.onreadystatechange = function() {
        if (request.readyState === XMLHttpRequest.DONE) {
            var responseData = JSON.parse(request.responseText);

            if (responseData.code !== 200) {
                onComplete(null);
                return false;
            }

            var buses = [];

            var arrivals = responseData.data.entry.arrivalsAndDepartures;

            for (var i = 0, leni = arrivals.length; i < leni; i++)
            {
                var busResponse = arrivals[i];

                // Parse unix timestamp
                var leaveTime = busResponse.predictedDepartureTime !== 0
                            ? new Date(busResponse.predictedDepartureTime)
                            : new Date(busResponse.scheduledDepartureTime);

                var countdown = Math.round((leaveTime - new Date()) / 1000 / 60);

                var bus = {
                    route: busResponse.routeShortName,
                    name: busResponse.tripHeadsign,
                    direction: "",
                    minutes: countdown,
                    departure: leaveTime.toDateString()
                };

                buses.push(bus);
            }

            onComplete(buses);
        }
    }

    request.send();
    return true;
}

