    // set up ========================
    var express  = require('express');
    var R = require("r-script");
    var app      = express();                              
    var morgan = require('morgan');
    var http = require('http').createServer(app); 
    var bodyParser = require('body-parser');    
    var methodOverride = require('method-override'); 

    //web server
    app.set('port', process.env.PORT || 3000);
    app.use(express.static(__dirname + '/public'));                 // set the static files location /public/img will be /img for users
    app.use(morgan('dev'));                                         // log every request to the console
    app.use(bodyParser.urlencoded({'extended':'true'}));            // parse application/x-www-form-urlencoded
    app.use(bodyParser.json());                                     // parse application/json
    app.use(bodyParser.json({ type: 'application/vnd.api+json' })); // parse application/vnd.api+json as json
    app.use(methodOverride());
    var counterui = 0;
    var notificationArr = [];
    var msg ="hello";
   
    app.get('/api/data', function(req, res) {
                // console.log("I have arrived");
                res.send(msg); 
    });
   

    

   app.post('/api/threshold', function(req, res) {
        console.log("successful POST");
        console.log("input is.....",req.body.first, req.body.second, req.body.third, req.body.fourth, req.body.fifth, req.body.sixth, req.body.seventh, req.body.eighth, req.body.ninth, req.body.tenth);
        if(req.body.tenth == "Linear"){
        console.log("Inside Linear Regression");    
        var linear = R("R/linear.R")
        .data(req.body.first, req.body.second, req.body.third, req.body.fourth, req.body.fifth, req.body.sixth, req.body.seventh,(req.body.eighth).split("T")[0]+" "+(req.body.eighth).split("T")[1], req.body.ninth)
        .callSync();
    
        }
        if(req.body.tenth == "Stepwise Linear"){
        console.log("Inside Stepwise Linear Regression");     
        var linear = R("R/step_linear.R")
        .data(req.body.first, req.body.second, req.body.third, req.body.fourth, req.body.fifth, req.body.sixth, req.body.seventh,(req.body.eighth).split("T")[0]+" "+(req.body.eighth).split("T")[1], req.body.ninth)
        .callSync();
        
        }
        if(req.body.tenth == "Principle Component"){
        console.log("Inside Principle Component"); 
        var linear = R("R/principle_component.R")
        .data(req.body.first, req.body.second, req.body.third, req.body.fourth, req.body.fifth, req.body.sixth, req.body.seventh,(req.body.eighth).split("T")[0]+" "+(req.body.eighth).split("T")[1], req.body.ninth)
        .callSync();
        
        }
        if(req.body.tenth == "Partial Least Sqaure"){
        console.log("Inside Partial Least Square Regression"); 
        var linear = R("R/partial_least_square.R")
        .data(req.body.first, req.body.second, req.body.third, req.body.fourth, req.body.fifth, req.body.sixth, req.body.seventh,(req.body.eighth).split("T")[0]+" "+(req.body.eighth).split("T")[1], req.body.ninth)
        .callSync();
      
        }
        if(req.body.tenth == "Gradient Boost Machine"){
        console.log("Inside Gradient Boost Machine Regression"); 
        var linear = R("R/gbm.R")
        .data(req.body.first, req.body.second, req.body.third, req.body.fourth, req.body.fifth, req.body.sixth, req.body.seventh,(req.body.eighth).split("T")[0]+" "+(req.body.eighth).split("T")[1], req.body.ninth)
        .callSync();
        
        }
        console.log("latitude: ", linear[0]);
        console.log("longitude: ", linear[1]);
        console.log((linear[0]+" "+linear[1]).split(" ")[0]);
        console.log((linear[0]+" "+linear[1]).split(" ")[1]);
        res.header("Access-Control-Allow-Origin", "*");
        res.send(linear[0]+" "+linear[1]);
        res.end();
    });

 
    http.listen(app.get('port'), function() {
        console.log('Express server listening on port ' + app.get('port'));
    });