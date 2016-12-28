var express = require('express');
var app = express();

//route to index.html
app.use('/', express.static(__dirname + '/public'));

//Start the server
var PORT = 3300;
app.listen(PORT, function(){
	console.log('listening on port ' + PORT);
});