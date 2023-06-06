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

(function () {
  goog.provide("gn_static_pages_directive");

  var module = angular.module("gn_static_pages_directive", ["ngSanitize"]);

  module.directive("gnStaticPagesViewer", [
    "$http",
    "$location",
    "$sce",
    function ($http, $location, $sce) {
      return {
        restrict: "AEC",
        replace: true,
        scope: {
          language: "@language"
        },
        templateUrl: "../../catalog/components/pages/partials/content.html",
        link: function ($scope) {
          $scope.loadPageContent = function () {
            var page = $location.search().page;

            $http({
              method: "GET",
              url: "../api/pages/" + $scope.language + "/" + page + "/content"
            }).then(
              function (response) {
                $sce.trustAsJs(response.data);
                // $sce.trustAsHtml(response.data);
                $scope.content = $sce.trustAsHtml(response.data);
              },
              function (response) {
                $scope.content = "Page not available";
                console.log(response.statusText);
              }
            );
          };

          function reloadPageContent() {
            $scope.loadPageContent();
          }

          $scope.$on("$locationChangeSuccess", reloadPageContent);

          $scope.loadPageContent();
        }
      };
    }
  ]);

  module.directive("gnStaticPagesListViewer", [
    "$http",
    "$location",
    "gnGlobalSettings",
    function ($http, $location, gnGlobalSettings) {
      return {
        restrict: "AEC",
        replace: true,
        scope: {
          language: "@language",
          section: "@section"
        },
        templateUrl: function (elem, attr) {
          return "../../catalog/components/pages/partials/" + attr.section + ".html";
        },
        link: function ($scope) {
          $scope.pagesMenu = [];
          function buildMenu(pagesMenu, pagesConfig) {
            pagesConfig.forEach(function (menu) {
              if (typeof menu === "string") {
                if ($scope.pages[menu]) {
                  pagesMenu.push($scope.pages[menu]);
                }
              } else if (angular.isObject(menu)) {
                var key = Object.keys(menu)[0],
                  submenu = {
                    label: key,
                    type: "submenu",
                    pages: []
                  };
                buildMenu(submenu.pages, menu[key]);
                pagesMenu.push(submenu);
              }
            });
          }

          $scope.loadPages = function () {
            $http({
              method: "GET",
              url:
                "../api/pages?language=" +
                $scope.language +
                "&section=" +
                $scope.section.toUpperCase()
            }).then(
              function (response) {
                var configKey = $scope.section === "footer" ? "footer" : "header";
                $scope.pagesConfig =
                  gnGlobalSettings.gnCfg.mods[configKey][$scope.section + "CustomMenu"];
                $scope.pagesMenu = [];
                $scope.pages = {};
                response.data.forEach(function (page) {
                  $scope.pages[page.pageId] = page;
                });
                buildMenu($scope.pagesMenu, $scope.pagesConfig);
              },
              function (response) {
                $scope.pagesList = null;
              }
            );
          };

          $scope.loadPages();
        }
      };
    }
  ]);
})();
