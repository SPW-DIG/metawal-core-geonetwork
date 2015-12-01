(function() {
  goog.provide('gn_abstract_builder_directive');

  var module = angular.module('gn_abstract_builder_directive', []);

  /**
   * 
   */
  module.directive('gnTextareaAbstractBuilder', ['$http',
    function($http) {

      return {
        restrict: 'A',
        replace:true,
        transclude: 'element',
        scope:true,
        templateUrl: '../../catalog/components/edit/' + 
        'abstractbuilder/partials/abstractbuilder.html',
        link: function(scope, element, attrs, ctrl, transclude) {
          $(element).find('textarea')[0].style.display = "none";
          var targetInput = $(element).find('textarea');
          //targetInput.style.visibility = "hidden";
          scope.maxChar = 160;
          scope.abstract = {
                hook: '',
                descriptive: ''
              };
          scope.abstractiso = '';
          //var targetInput = $(element).find('textarea');
              
          if (targetInput !== undefined) {
            scope.abstractiso = $(targetInput.get(0)).val();
            if (scope.abstractiso !== '') {
              var tokens = scope.abstractiso.split("\n\n");
              if (tokens.length >=2){
                scope.abstract.hook = tokens[0];
                scope.abstract.descriptive = tokens[1];
              } else {
                scope.abstract.descriptive = scope.abstractiso;
              }
            }
          }

          var buildAbstract = function() {
            scope.abstractiso = 
                        (scope.abstract.hook.length === 0 ? '' : 
                          (scope.abstract.hook + '\n\n')) + 
                        scope.abstract.descriptive;
             $(targetInput.get(0)).val(scope.abstractiso);
            };
          scope.$watch('abstract', function(newValue, oldValue) {              
            if (newValue !== oldValue) {
              buildAbstract();
            }
          }, true);
        }
      };
    }]);
})();