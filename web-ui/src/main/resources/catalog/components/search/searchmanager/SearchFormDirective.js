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
  goog.provide('gn_search_form_controller');










  goog.require('gn_catalog_service');
  goog.require('gn_facets');
  goog.require('gn_search_form_results_directive');
  goog.require('gn_selection_directive');
  goog.require('search_filter_tags_directive');

  var module = angular.module('gn_search_form_controller', [
    'gn_catalog_service',
    'gn_facets',
    'gn_selection_directive',
    'gn_search_form_results_directive',
    'search_filter_tags_directive'
  ]);

  /**
   * Controller to create new metadata record.
   */
  var searchFormController =
      function($scope, $location, gnSearchManagerService,
               gnFacetService, Metadata, gnSearchLocation) {
    var defaultParams = {
      fast: 'index',
      _content_type: 'json'
    };
    var self = this;

    var hiddenParams = $scope.searchObj.hiddenParams;

    /** State of the facets of the current search */
    $scope.currentFacets = [];

    /** Object where are stored result search information */
    $scope.searchResults = {
      records: [],
      count: -1,
      selectionBucket:
          $scope.searchObj.selectionBucket ||
          (Math.random() + '').replace('.', '')
    };
    $scope.finalParams = {};

    $scope.searching = 0;
    $scope.paginationInfo = $scope.paginationInfo || {};

    /**
     * Return the current search parameters.
     **/
    this.getSearchParams = function() {
      return $scope.searchObj.params;
    };

    this.getFinalParams = function() {
      return $scope.finalParams;
    };

    this.getSearchResults = function() {
      return $scope.searchResults;
    };

    /**
     * Tells if there is a pagination directive nested to this one.
     * Mainly activated by pagination directive link function.
     */
    $scope.hasPagination = false;
    this.activatePagination = function() {
      $scope.hasPagination = true;
      if (!$scope.searchObj.permalink || (
          angular.isUndefined($scope.searchObj.params.from) &&
          angular.isUndefined($scope.searchObj.params.to)
          )) {
        self.resetPagination();
      }
    };



    /**
     * Reset pagination 'from' and 'to' params and merge them
     * to $scope.params
     */
    this.resetPagination = function(customPagination) {
      if ($scope.hasPagination) {
        $scope.paginationInfo.currentPage = 1;
        this.updateSearchParams(this.getPaginationParams(customPagination));
      }
    };

    var cleanSearchParams = function(params) {
      for (v in params) {
        if (params[v] == '') {
          delete params[v];
        }
      }
    };

    /**
     * triggerSearch
     *
     * Run a search with the actual $scope.params
     * merged with the params from facets state.
     * Update the paginationInfo object with the total
     * count of metadata found.
     *
     * @param {boolean} resetPagination If true, then
     * don't reset pagination info.
     */

    this.triggerSearchFn = function(keepPagination) {
      $scope.searching++;
      $scope.searchObj.params = angular.extend({},
          $scope.searchObj.defaultParams || defaultParams,
          $scope.searchObj.params,
          defaultParams);

      // Add hidden filters which may
      // restrict search
      /*if ($scope.searchObj.filters) {
        angular.forEach($scope.searchObj.filters,
            function(value, key) {
              var p = $scope.searchObj.params[key];
              if (p) {
                if (p !== value && (!p.indexOf || p.indexOf(value) === -1)) {
                  if (!angular.isArray(p)) {
                    $scope.searchObj.params[key] = [p];
                  }
                  $scope.searchObj.params[key].push(value);
                }
              } else {
                $scope.searchObj.params[key] = value;
              }
            });
      }*/


      // Add hidden filters which may
      // restrict search
      // MW3.4 limit incremetation type in request
      if ($scope.searchObj.filters) {
        angular.forEach($scope.searchObj.filters,
            function(value, key) {
              var p = $scope.searchObj.params[key];
              if (key != 'type') {
                  if (p) {
                    if (!angular.isArray(p)) {
                      $scope.searchObj.params[key] = [p];
                    }
                    $scope.searchObj.params[key].push(value);

                  } else {
                    $scope.searchObj.params[key] = value;
                  }
              }else { if ($scope.searchObj.params[key]) {} else {$scope.searchObj.params[key] = value}}
            });
      }

      // Set default pagination if not set
      if ((!keepPagination &&
          !$scope.searchObj.permalink) ||
          (angular.isUndefined($scope.searchObj.params.from) ||
          angular.isUndefined($scope.searchObj.params.to))) {
        self.resetPagination();
      }

      // Set default sortBy
      if (angular.isUndefined($scope.searchObj.params.sortBy)) {
        angular.extend($scope.searchObj.params, $scope.searchObj.sortbyDefault);
      }

      // Don't add facet extra params to $scope.params but
      // compute them each time on a search.
      var params = angular.copy($scope.searchObj.params);

      if ($scope.currentFacets.length > 0) {
        angular.extend(params,
            gnFacetService.getParamsFromFacets($scope.currentFacets));
      }

      params.bucket = $scope.searchResults.selectionBucket || 'metadata';

      var finalParams = angular.extend(params, hiddenParams);
      $scope.finalParams = finalParams;
      gnSearchManagerService.gnSearch(finalParams).then(

          function(data) {

            // TEST WOM  START//
            //$scope.womTOC =  function() {
              // var result = _.findWhere(data.dimension, {@name: 'geoportailThemeLabel'});
             // console.log('result');
              //console.log(result);

              // Create list of thesaurus and labels (all languages)//
              if (data.length != 0){
                if (data.dimension.length != 0){
                  // console.log(data.dimension);
                  if (data.dimension.length != 0){
                    // console.log(data.dimension);
                    var elementThesaurusLabel = data.dimension.find(function(item){
                      return item['@name'] == 'geoportailThemeLabel';
                    });
                    if (elementThesaurusLabel) {
                      var elementThesaurusLabel = data.dimension.find(function(item){
                          return item['@name'] == 'geoportailThemeLabel';
                      });
                      var thesausuLabelList=[];
                      // console.log(elementThesaurusLabel);
                      if (elementThesaurusLabel.category){
                        for (var i = 0; i < elementThesaurusLabel.category.length; i++) {
                          var list = []
                          list.id = elementThesaurusLabel.category[i]['@label'].split('=')[0];
                          list.element = elementThesaurusLabel.category[i]['@label'].split('=')[1].split('|');
                          thesausuLabelList.push(list);
                        }
                        var elementTheme = data.dimension.find(function(item){
                            return item['@name'] == 'geoportailTheme';
                        });
                        for (var i = 0; i < elementTheme.category.length; i++) {
                          for (var j = 0; j < thesausuLabelList.length; j++) {
                            if (thesausuLabelList[j].id.includes(elementTheme.category[i]['@value'])) {
                              elementTheme.category[i]["i18nLavel"]=thesausuLabelList[j].element;
                              elementTheme.category[i]["records"]=[];
                              elementTheme.category[i]["idTheme"]=elementTheme.category[i]['@value'].split('/').slice(-1)[0];
                              //console.log(elementTheme.category[i]['@value'].split('/').slice(-1));
                            }
                          }
                          if (elementTheme.category[i].category) {
                            for (var k = 0; k < elementTheme.category[i].category.length; k++) {
                              for (var l = 0; l < thesausuLabelList.length; l++) {
                                if (thesausuLabelList[l].id.includes(elementTheme.category[i].category[k]['@value'])) {
                                  elementTheme.category[i].category[k]["i18nLavel"]=thesausuLabelList[l].element;
                                  elementTheme.category[i].category[k]["records"]=[];
                                  elementTheme.category[i].category[k]["idTheme"]=elementTheme.category[i].category[k]['@value'].split('/').slice(-1)[0];
                                }
                              }
                            }
                          }
                        }
                        $scope.toc = elementTheme.category;
                        for (var i = 0; i < data.metadata.length; i++) {
                          for (var j = 0; j < $scope.toc.length; j++){
                            for (var k = 0; k < data.metadata[i].keyword.length; k++) {
                              if ($scope.toc[j]['category']) {
                                if ($scope.toc[j]['i18nLavel'] && $scope.toc[j]['i18nLavel'].includes(data.metadata[i].keyword[k])) {
                                  $scope.toc[j].records.push(new Metadata(data.metadata[i]));
                                }
                                for (var l = 0; l < $scope.toc[j].category.length; l++) {
                                  if ($scope.toc[j].category[l]['i18nLavel'].includes(data.metadata[i].keyword[k])) {
                                    $scope.toc[j].category[l].records.push(new Metadata(data.metadata[i]));
                                  }
                                }
                              } else {
                                if ($scope.toc[j]['i18nLavel'].includes(data.metadata[i].keyword[k])) {
                                  $scope.toc[j].records.push(new Metadata(data.metadata[i]));
                                }
                              }
                              //console.log(data.metadata[i].keyword[k]);
                              /*if($scope.toc[j]['i18nLavel'].includes(data.metadata[i].keyword[k])) {
                                $scope.toc[j].records.push(new Metadata(data.metadata[i]));
                              }
                              else {
                                //console.log($scope.toc[j]);
                                for (var l = 0; l < $scope.toc[j].category.length; l++) {
                                  if ($scope.toc[j].category[l]['i18nLavel'].includes(data.metadata[i].keyword[k])) {
                                    $scope.toc[j].category[l].records.push(new Metadata(data.metadata[i]));
                                  }
                                }
                              }*/
                            }
                          }
                        }
                      }
                    } else {
                      // console.log("noki");
                    }
                  }
                }
              }
            // TEST WOM END//



            $scope.searching--;
            $scope.searchResults.records = [];
            for (var i = 0; i < data.metadata.length; i++) {
              $scope.searchResults.records.push(new Metadata(data.metadata[i]));
            }
            $scope.searchResults.count = data.count;
            $scope.searchResults.facet = data.facet;
            $scope.searchResults.dimension = data.dimension;
            // compute page number for pagination
            if ($scope.hasPagination) {

              var paging = $scope.paginationInfo;

              // Means the `from` and `to` params come from permalink
              if ((paging.currentPage - 1) *
                  paging.hitsPerPage + 1 != params.from) {
                paging.currentPage = (params.from - 1) / paging.hitsPerPage + 1;
              }

              paging.resultsCount = $scope.searchResults.count;
              paging.to = Math.min(
                  data.count,
                  paging.currentPage * paging.hitsPerPage
                  );
              paging.pages = Math.ceil(
                  $scope.searchResults.count /
                  paging.hitsPerPage, 0
                  );
              paging.from = (paging.currentPage - 1) * paging.hitsPerPage + 1;
            }
          }).finally(function() {
        $scope.searching--;
      });
    };


    /**
     * triggerWildSubtemplateSearch
     *
     * Run a search with the actual $scope.params
     * merged with the params from facets state.
     * Update the paginationInfo object with the total
     * count of metadata found. Note that this search
     * is for subtemplates with _root element provided as function
     * param and wildcard char appended
     */
    this.triggerWildSubtemplateSearch = function(element) {

      angular.extend($scope.params, defaultParams);

      // Don't add facet extra params to $scope.params but
      // compute them each time on a search.
      var params = angular.copy($scope.params);
      if ($scope.currentFacets.length > 0) {
        angular.extend(params,
            gnFacetService.getParamsFromFacets($scope.currentFacets));
      }

      // Add wildcard char to search, limit to subtemplates and the _root
      // element of the subtemplate we want
      if (params.any) params.any = params.any + '*';
      else params.any = '*';

      params._isTemplate = 's';
      params._root = element;
      params.from = '1';
      params.to = '20';

      gnSearchManagerService.gnSearch(params).then(
          function(data) {
            $scope.searchResults.records = data.metadata;
            $scope.searchResults.count = data.count;
            $scope.searchResults.facet = data.facet;

            // compute page number for pagination
            if ($scope.searchResults.records.length > 0 &&
                $scope.hasPagination) {
              $scope.paginationInfo.pages = Math.ceil(
                  $scope.searchResults.count /
                      $scope.paginationInfo.hitsPerPage, 0);
            }
          });
    };

    /**
     * If we use permalink, the triggerSerach call will in fact just update
     * the url with the params, then the event $locationChangeSuccess will call
     * the geonetwork search from url params.
     */
    if ($scope.searchObj.permalink) {
      var triggerSearchFn = self.triggerSearchFn;
      var facetsParams;

      self.triggerSearch = function(keepPagination) {
        if (!keepPagination) {
          self.resetPagination();
        }

        facetsParams = gnFacetService.getParamsFromFacets($scope.currentFacets);
        $scope.$broadcast('beforesearch');
        var params = angular.copy($scope.searchObj.params);
        cleanSearchParams(params);
        angular.extend(params, facetsParams);

        if (angular.equals(params, $location.search())) {
          triggerSearchFn(false);
        } else {
          gnSearchLocation.setSearch(params);
        }
      };

      $scope.$on('$locationChangeSuccess', function(e, newUrl, oldUrl) {
        // We are not in a url search so leave
        if (!gnSearchLocation.isSearch()) return;

        // We are getting back to the search, no need to reload it
        if (newUrl == gnSearchLocation.lastSearchUrl) return;

        var params = angular.copy($location.search());
        gnFacetService.removeFacetsFromParams($scope.currentFacets, params);

        for (var o in facetsParams) {
          delete params[o];
        }

        $scope.searchObj.params = params;
        triggerSearchFn();
      });
    }
    else {
      this.triggerSearch = this.triggerSearchFn;
    }

    /**
     * update $scope.params by merging it with given params
     * @param {!Object} params
     */
    this.updateSearchParams = function(params) {
      angular.extend($scope.searchObj.params, params);
    };

    this.resetSearch = function(searchParams) {

      $scope.$broadcast('beforeSearchReset');

      if (searchParams) {
        $scope.searchObj.params = searchParams;
      } else {
        $scope.searchObj.params = {};
      }
      if ($scope.searchObj.sortbyDefault) {
        angular.extend($scope.searchObj.params, $scope.searchObj.sortbyDefault);
      }

      var customPagination = searchParams;

      self.resetPagination(customPagination);
      $scope.currentFacets = [];
      $scope.triggerSearch();
      $scope.$broadcast('resetSelection');
    };
    $scope.$on('resetSearch', function(evt, searchParams) {
      $scope.controller.resetSearch(searchParams);
    });

    $scope.$on('search', function() {
      $scope.triggerSearch();
    });

    $scope.$on('clearResults', function() {
      $scope.searchResults = {
        records: [],
        count: 0,
        selectionBucket: $scope.searchObj.selectionBucket
      };
    });

    $scope.triggerSearch = this.triggerSearch;
    $scope.triggerWildSubtemplateSearch = this.triggerWildSubtemplateSearch;
  };

  searchFormController['$inject'] = [
    '$scope',
    '$location',
    'gnSearchManagerService',
    'gnFacetService',
    'Metadata',
    'gnSearchLocation'
  ];

  /**
   * Possible attributes:
   *  * runSearch: run search inmediately after the  directive is loaded.
   *  * waitForUser: wait until a user id is available to trigger the search.
   */
  module.directive('ngSearchForm', [
    'gnSearchLocation',
    function(gnSearchLocation) {
      return {
        restrict: 'A',
        scope: true,
        controller: searchFormController,
        controllerAs: 'controller',
        link: function(scope, element, attrs) {

          scope.resetSearch = function(htmlElementOrDefaultSearch) {
            if (angular.isObject(htmlElementOrDefaultSearch)) {
              scope.controller.resetSearch(htmlElementOrDefaultSearch);
            } else {
              scope.controller.resetSearch();
              $(htmlElementOrDefaultSearch).focus();
            }
          };

          var waitForPagination = function() {
            // wait for pagination to be set before triggering search
            if (element.find('[data-gn-pagination]').length > 0) {
              var unregisterFn = scope.$watch('hasPagination', function() {
                if (scope.hasPagination) {
                  scope.triggerSearch(true);
                  unregisterFn();
                }
              });
            } else {
              scope.triggerSearch(false);
            }
            if (element.find('[data-gn-api-rw-pagination]').length > 0) {
              var unregisterFn = scope.$watch('hasPagination', function() {
                if (scope.hasPagination) {
                  scope.triggerSearch(true);
                  unregisterFn();
                }
              });
            } else {
              scope.triggerSearch(false);
            }
          };

          // Run a first search on directive rendering if attr is specified
          // Don't run it on page load if the permalink is 'on' and the
          // $location is not set to 'search'
          if (attrs.runsearch &&
              (!scope.searchObj.permalink || gnSearchLocation.isSearch())) {

            // get permalink params on page load
            if (scope.searchObj.permalink) {
              angular.extend(scope.searchObj.params,
                  gnSearchLocation.getParams());
            }

            if (attrs.waitForUser === true) {
              var userUnwatch = scope.$watch('user.id', function(userNewVal) {
                // Don't trigger the search until the user id has been loaded
                // Unregister the watch once we have the user id.
                if (angular.isDefined(userNewVal)) {
                  waitForPagination();
                  userUnwatch();
                }
              });
            } else {
              waitForPagination();
            }
          }
        }
      };
    }]);
})();
