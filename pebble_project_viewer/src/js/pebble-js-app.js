// Function to send a message to the Pebble using AppMessage API
function sendMessage() {
	Pebble.sendAppMessage({"status": 0, "message": "Hi Pebble, I'm a Phone!"});
	
	// PRO TIP: If you are sending more than one message, or a complex set of messages, 
	// it is important that you setup an ackHandler and a nackHandler and call 
	// Pebble.sendAppMessage({ /* Message here */ }, ackHandler, nackHandler), which 
	// will designate the ackHandler and nackHandler that will be called upon the Pebble 
	// ack-ing or nack-ing the message you just sent. The specified nackHandler will 
	// also be called if your message send attempt times out.
}


// Called when JS is ready
Pebble.addEventListener("ready",
    function(e) {
    });
												
// Called when incoming message from the Pebble is received
Pebble.addEventListener("appmessage",
function(e) {
    console.log("Received Status: " + e.payload[0]);
    console.log("Received Message: " + e.payload[1]);
    sendMessage();
});

function HTTPGET(url) {
    var req = new XMLHttpRequest();
    req.open("GET", url, false);
    req.send(null);
    return req.responseText;
}

var getProjects = function() {
    var response = HTTPGET("http://night-stalker.herokuapp.com/projects.json");
    var json = JSON.parse(response);
    
    for (var i = 0; i < json.length; i++) {
        console.log("Name is " + json[i].name);
        
        var dict = {"KEY_STATUS" : i, "KEY_MESSAGE" : json[i].name, "KEY_SUM" : json[i].minutes};
        
        Pebble.sendAppMessage(dict);
    }
};

Pebble.addEventListener("ready", function(e) {
    getProjects();
});

Pebble.addEventListener("appmessage", function(e) {
    getProjects();
} );