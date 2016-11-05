      angular.module('app', ['ngSanitize', 'toggle-switch', 'ui-notification']);
      angular.module('main', [
    'app',
    'ngRoute',
    'ngCookies'
])

.config(['$routeProvider', function ($routeProvider) {

    $routeProvider
 
        .when('/', {
            controller: 'mainController',
            templateUrl: 'modules/dashboard/views/predict.html'
        })
        .when('/dashboard', {
            controller: 'mainController',
            templateUrl: 'modules/dashboard/views/dashboard.html'
        });

}]);
 
// .run(['$rootScope', '$location', '$cookieStore', '$http',
//     function ($rootScope, $location, $cookieStore, $http) {
//         // keep user logged in after page refresh
//         $rootScope.globals = $cookieStore.get('globals') || {};
//         if ($rootScope.globals.currentUser) {
//             $http.defaults.headers.common['login'] = 'Basic ' + $rootScope.globals.currentUser.authdata; // jshint ignore:line
//         }
 
        
//     }]);
