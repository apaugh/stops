Stops aims to make it easy to add new backends for new regions. Each backend exists as a single file in the js folder, and fulfill a standard contract.

To create a new backend, you need to implement two functions in a .js file:
	
	getStopInfoRequest(stopNumber, key, onComplete)
		stopNumber: Transit stop number.
		key: Api key.
		onComplete: A callback that takes an instance of the StopInfo class. Called when the request completes.

	getEstimatesRequest(stopNumber, key, onComplete)
		stopNumber: Transit stop number.
	        key: Api key.
		onComplete: A callback that takes an instance of the Estimates class. Called when the request completes.

Once you have implemented the two functions, add your backend to the array in Backend.qml.

Provide the maintainer with an api key, which they will locally add to keys.js.
