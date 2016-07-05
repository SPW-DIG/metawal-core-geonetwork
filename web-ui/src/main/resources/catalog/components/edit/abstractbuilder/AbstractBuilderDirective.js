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
            //$(element).find('textarea#hook')[0].style.height=$(element).find('textarea#hook')[0].scrollHeight +'px';
            //console.log(($(element).find('textarea#hook')[0].style.height));
            if ($(element).find('textarea#hook')[0].scrollHeight > 55) {
              $(element).find('textarea#hook')[0].style.height=$(element).find('textarea#hook')[0].scrollHeight +'px'; 
            } else{
              $(element).find('textarea#hook')[0].style.height='55px';
            }
            if ($(element).find('textarea#description')[0].scrollHeight > 110) {
              $(element).find('textarea#description')[0].style.height=$(element).find('textarea#description')[0].scrollHeight +'px'; 
            } else{
              $(element).find('textarea#description')[0].style.height='110px';
            }
            //$(element).find('textarea#description')[0].style.height=$(element).find('textarea#description')[0].scrollHeight +'px';           
            if (newValue !== oldValue) {
              buildAbstract();
            }
          }, true);
          //autosize textarea//
          
         /* jQuery.each(jQuery('textarea[data-autoresize]'), function() {
              var offset = this.offsetHeight - this.clientHeight;
           
              var resizeTextarea = function(el) {
                  jQuery(el).css('height', 'auto').css('height', el.scrollHeight + offset);
              };
              jQuery(this).on('keyup input', function() { resizeTextarea(this); }).removeAttr('data-autoresize');
          });*/
          
        }
      };
    }]);
})();