(function() {
  goog.provide('gn_importxsl_directive');

  var module = angular.module('gn_importxsl_directive', []);

  /**
     * Provide a list of available XSLT transformation
     *
     */
  module.directive('gnImportXsl', ['$http', '$translate',
    function($http, $translate) {

      return {
        restrict: 'A',
        replace: true,
        transclude: true,
        scope: {
          element: '=gnImportXsl'
        },
        templateUrl: '../../catalog/components/admin/importxsl/partials/' +
            'importxsl.html',
        link: function(scope, element, attrs) {
          $http.get('info@json?type=importStylesheets').success(function(data) {
            scope.stylesheets = data.stylesheets;
          });
        }
      };
    }]);
})();
