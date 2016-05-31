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
  goog.provide('gn_category_directive');

  var module = angular.module('gn_category_directive', []);

  /**
     * Provide a list of categories if at least one
     * exist in the catalog
     *
     */
  module.directive('gnCategory', ['$http', '$translate',
    function($http, $translate) {

      return {
        restrict: 'A',
        replace: true,
        transclude: true,
        scope: {
          element: '=gnCategory',
          lang: '@lang',
          label: '@label'
        },
        templateUrl: '../../catalog/components/category/partials/' +
            'category.html',
        link: function(scope, element, attrs) {
          $http.get('info?_content_type=json&type=categories', {cache: true}).
              success(function(data) {
                scope.categories = data.metadatacategory;
              }).error(function(data) {
                // TODO
              });
        }
      };
    }]);

  module.directive('gnBatchCategories', [
    '$http', '$translate', '$q',
    function($http, $translate, $q) {

      return {
        restrict: 'A',
        replace: true,
        transclude: true,
        templateUrl: '../../catalog/components/category/partials/' +
            'batchcategory.html',
        link: function(scope, element, attrs) {
          scope.report = null;

          $http.get('info?_content_type=json&type=categories', {cache: true}).
              success(function(data) {
                scope.categories = data.metadatacategory;
              }).error(function(data) {
                // TODO
              });

          scope.save = function(replace) {
            scope.report = null;
            var defer = $q.defer();
            var params = {};
            var url = 'md.category.batch.update?_content_type=json';

            if (replace) {
              url += '&mode=add';
            }

            angular.forEach(scope.categories, function(c) {
              if (c.checked === true) {
                params['_' + c['@id']] = 'on';
              }
            });
            $http.get(url, {params: params})
                .success(function(data) {
                  scope.report = data;
                  defer.resolve(data);
                }).error(function(data) {
                  scope.report = data;
                  defer.reject(data);
                });
            return defer.promise;
          };
        }
      };
    }]);
})();
