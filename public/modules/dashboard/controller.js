var accident = angular.module('app', ['ngSanitize', 'toggle-switch', 'ui-notification']);

accident.controller('mainController', function ($scope, $http, Notification, $interval) {

        var num = 0.0;
        var n;      
        $scope.num = num;
        $scope.count = 0;
        $scope.prevval = 0;
        $scope.distData = 0;
        $scope.lightData = 0;
        $scope.notifications = [];
        //$scope.switchStatus = true;
        $scope.thrs = new Threshold(n);
        $scope.first;
        $scope.second;
        $scope.third;
        $scope.fourth;
        $scope.fifth;
        $scope.sixth;
        $scope.seventh;
        $scope.eighth;
        $scope.ninth;
        $scope.tenth;
        $scope.lat;
        $scope.longitude;
         $scope.lin ;
                $scope.step ;
                $scope.prin ;
                $scope.par ;
                $scope.gbm ;


        // $scope.init = function () {
        //   $http.get('/api/currentState')
        //   .success(function(response) {
        //   console.log(response);
        //   $scope.currentSt = response;
        //   $scope.switchStatus = $scope.currentSt.SensorState;
        //   $scope.thrs = new Threshold($scope.currentSt.ThresholdVal);
        //   console.log($scope.currentSt.SensorState);
        // })
        // .error(function(data) {
        //     console.log('Error: ' + data);
        //   });
        // }
        //$scope.init();

        $scope.sendVal = function() {
          console.log("thrs value is:" + JSON.stringify($scope.first,$scope.second,$scope.third,
        $scope.fourth,
        $scope.fifth,
        $scope.sixth,
        $scope.seventh,
        $scope.eighth,
        $scope.ninth,
        $scope.tenth));
          $http.post('/api/threshold', $scope.thrs)
            .success(function(data) {
                $scope.lat = data.split(" ")[0];
                $scope.longitude = data.split(" ")[1]; 
                $scope.lin = 0.86;
                $scope.step = 0.83;
                $scope.prin = 0.89;
                $scope.par = 0.87;
                $scope.gbm = 0.90;
            })
            .error(function(data) {
                console.log('Error: ' + data);
            });
        };

     

  });
    
    function Threshold(current) {
    var thrs = current;

    this.__defineGetter__("thrs", function () {
        return thrs;
    });

    this.__defineSetter__("thrs", function (val) {        
        val = parseInt(val);
        thrs = val;
    });
  }