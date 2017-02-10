/*
 * Copyright (C) 2001-2016 Food and Agriculture Organization of the
 * United Nations (FAO-UN), United Nations World Food Programme (WFP)
 * and United Nations Environment Programme (UNEP)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
 *
 * Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
 * Rome - Italy. email: geonetwork@osgeo.org
 */
(function() {
  goog.provide('gn_abstract_builder_directive');

  var module = angular.module('gn_abstract_builder_directive', []);

  module.directive('gnTextareaAbstractBuilder', ['$http',
    function($http) {

      return {
        restrict: 'A',
        replace: true,
        transclude: 'element',
        scope: true,
        templateUrl: '../../catalog/components/edit/' +
            'abstractbuilder/partials/abstractbuilder.html',
        link: function(scope, element) {
          $(element).find('textarea')[0].style.display = 'none';
          var targetInput = $(element).find('textarea');
          scope.maxChar = 160;
          scope.abstract = {
                hook: '',
                descriptive: ''
              };
          scope.abstractiso = '';

          if (targetInput !== undefined) {
            scope.abstractiso = $(targetInput.get(0)).val();
            if (scope.abstractiso !== '') {
              var tokens = scope.abstractiso.split('\n\n');
              if (tokens.length >= 2) {
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
            if ($(element).find('textarea#hook')[0].scrollHeight > 55) {
              $(element).find('textarea#hook')[0].style.height =
                  $(element).find('textarea#hook')[0].scrollHeight + 'px';
            } else {
              $(element).find('textarea#hook')[0].style.height = '55px';
            }
            if ($(element).find('textarea#description')[0].scrollHeight > 110) {
              $(element).find('textarea#description')[0].style.height =
                  $(element).find('textarea#description')[0].
                  scrollHeight + 'px';
            } else {
              $(element).find('textarea#description')[0].
                  style.height = '110px';
            }
            if (newValue !== oldValue) {
              buildAbstract();
            }
          }, true);

        }
      };
    }]);
})();
