.pragma library

function getStopInfo(stopNumber, apiKey, onComplete) {
    var request = new XMLHttpRequest();
    var url = "http://api.translink.ca/rttiapi/v1/stops/" + stopNumber + "?apikey=" + apiKey
    request.open("GET", url, true);
    request.setRequestHeader("Accepts", "application/json");
    request.setRequestHeader("Content-Type", "application/json");

    request.onreadystatechange = function() {
        if (request.readyState === XMLHttpRequest.DONE) {
            var responseData = JSON.parse(request.responseText);

            // Create the result object.
            var result = {
                name: responseData.Name,
                routes: responseData.Routes
            }

            onComplete(result);
        }
    }

    request.send();
    return true;
}

function getStopEstimates(stopNumber, apiKey, onComplete) {
    var request = new XMLHttpRequest();
    var url = "http://api.translink.ca/rttiapi/v1/stops/" + stopNumber + "/estimates?TimeFrame=120&apikey=" + apiKey
    request.open("GET", url, true);
    request.setRequestHeader("Accepts", "application/json");
    request.setRequestHeader("Content-Type", "application/json");

    request.onreadystatechange = function() {
        if (request.readyState === XMLHttpRequest.DONE) {
            var responseData = JSON.parse(request.responseText);

            var buses = [];

            for (var i = 0, leni = responseData.length; i < leni; i++)
            {
                var busResponse = responseData[i];

                for (var j = 0, lenj = busResponse.Schedules.length; j < lenj; j++)
                {
                    var instanceResponse = busResponse.Schedules[j];

                    var bus = {
                        route: busResponse.RouteNo,
                        name: busResponse.RouteName,
                        direction: busResponse.Direction,
                        minutes: instanceResponse.ExpectedCountdown,
                        departure: instanceResponse.ExpectedLeaveTime
                    };

                    buses.push(bus);
                }
            }

            onComplete(buses);
        }
    }

    request.send();
    return true;
}

