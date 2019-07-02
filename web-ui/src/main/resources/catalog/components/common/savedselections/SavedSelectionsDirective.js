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
  goog.provide('gn_saved_selections_directive');

  var module = angular.module('gn_saved_selections_directive',
    []);

  module.factory('gpBasketService', ['$http', function($http) {
    return {
      gpbasket: function(url){
        var promise = $http.get(url)
        .then(function(response) {
          console.log(response);
          return response.data;
        },
        function(error){
          return error;
        })
        return promise
      }
    };
  }]);



  module.factory('gnSavedSelectionConfig', [
    '$location', 'Metadata', 'gnMap', 'gnSearchSettings', '$window', '$http', 'gnExternalViewer',
    function($location, Metadata, gnMap, gnSearchSettings, $window, $http, gnExternalViewer) {
      var viewerMap = gnSearchSettings.viewerMap;
      var searchRecordsInSelection = function(uuid, records) {
        // TODO: Redirect to search app if not in a search page
        $location.path('/search').search('_uuid', uuid.join(' or '));
      };
      return {
        // Actions defined for each type of list to
        // trigger something on this selection (eg.
        // run a search to display only this saved
        // selection content.
        actions: {
          'PreferredList': {
            label: 'searchSelectedRecord',
            fn: searchRecordsInSelection,
            icon: 'fa-search',
            icon_result: 'icon-api-rw-service',
            text_noselected: 'noSearchSelectedRecord'
          },
          'AnonymousUserlist': {
            label: 'searchSelectedRecord',
            fn: searchRecordsInSelection,
            icon: 'fa-search',
            icon_result: 'icon-api-rw-notification',
            text_noselected: 'noSearchSelectedRecord'
          },
          'MapLayerlist': {
            label: 'addToMap',
            filterFn: function(record) {
              var md = new Metadata(record);
              return md.getLinksByType('OGC:WMS').length > 0;
            },
            fn: function(uuids, records) {
              for (var i = 0; i < uuids.length; i++) {
                var uuid = uuids[i], record = records[uuid];

                var md = new Metadata(record);
                angular.forEach(md.getLinksByType('OGC:WMS'), function(link) {
                  if (gnExternalViewer.isEnabled()) {
                    gnExternalViewer.viewService({
                      id: md.getId(),
                      uuid: md.getUuid()
                    }, {
                      url: link.url,
                      type: 'wms',
                      name: link.name,
                      title: link.title
                    })
                    return;
                  }

                  if (gnMap.isLayerInMap(viewerMap,
                    link.name, link.url)) {
                    return;
                  }
                  gnMap.addWmsFromScratch(viewerMap,
                    link.url, link.name,
                    false, md).then(function(layer) {
                    if (layer) {
                      gnMap.feedLayerWithRelated(layer, link.group);
                    }
                  });
                });
              }
            },
            apirw: function(uuids, records) {
              var mapbasket = [];
              var url = 'http://geoportail.wallonie.be/files/' +
                'GeoViewer/Main/index.html#panier=';
              for (var i = 0; i < uuids.length; i++) {
                var uuid = uuids[i], record = records[uuid];
                var md = new Metadata(record);
                var elem = {};
                elem['metadataUrl'] = $location.$$protocol + '://' +
                  $location.$$host + ':' + $location.$$port +
                  '/geonetwork/srv/eng/catalog.search#' +
                  '/metadata/' + md.getUuid();
                elem['label'] = md.defaultTitle;
                elem['serviceId'] = md.getUuid();
                if (md.getLinksByType('ESRI:REST').length > 0) {
                  elem['type'] = 'AGS_DYNAMIC';
                  elem['url'] = md.getLinksByType('ESRI:REST')[0].url;
                }
                else if (md.getLinksByType('OGC:WMS').length > 0) {
                  elem['type'] = 'WMS';
                  elem['url'] = md.getLinksByType('OGC:WMS')[0].url;
                }
                else if (md.getLinksByType('OGC:WMTS').length > 0) {
                  elem['type'] = 'WMTS';
                  elem['url'] = md.getLinksByType('OGC:WMTS')[0].url;
                }
                mapbasket.push(elem);
              }
              //console.log(url+JSON.stringify(mapbasket));
              $window.open(url + JSON.stringify(mapbasket));
            },
            icon: 'fa-globe',
            icon_result: 'icon-api-rw-walonmap',
            text_noselected: 'noAddToMap'
          },
          'DataDownloaderlist': {
            label: 'downloadData',
            filterFn: function(record) {
              var md = new Metadata(record);
              // TODO: Check when this action is displayed in metawal ?
              return md.getLinksByType('ESRI:REST').length > 0;
            },
            fn: function(uuids, records) {
              var uuidList = [];
              for (var i = 0; i < uuids.length; i++) {
                var uuid = uuids[i], record = records[uuid];
                var md = new Metadata(record);
                uuidList.push(uuid);
              }
              window.open('http://geoportail.wallonie.be/sites/geoportail/' +
                'geodata-donwload.html?uuids=' +
                uuidList.join(','), 'download');
            },
            icon: 'fa-download',
            icon_result: 'icon-api-rw-download',
            text_noselected: 'noDownloadData'
          }
        },
        // Add user session selection types
        // * MapLayerList is a local selection used to add
        //   multiple layers in one go
        // * AnonymousUserList is a list of preferred records
        //   for anonymous user only stored in localStorage.
        localList: [ {
          id: -10,
          name: 'MapLayerlist',
          records: [],
          storage: 'localStorage'
        }, {
          id: -20,
          name: 'DataDownloaderlist',
          records: [],
          storage: 'localStorage'
        }, {
          id: -30,
          name: 'AnonymousUserServicelist',
          records: [],
          storage: 'localStorage',
          isAnonymousOnly: true
        },{
          id: -40,
          name: 'AnonymousUserlist',
          records: [],
          // Can be localStorage, sessionStorage or
          // null (ie. not preserved on page refresh).
          storage: 'localStorage',
          isAnonymousOnly: true
        }]
      };
    }]);

  /**
   * @ngdoc directive
   * @name gn_saved_selections.directive:gnSavedSelections
   * @restrict A
   * @requires gnSavedSelectionsService
   * @requires $translate
   *
   * @description
   *
   */
  module.directive('gnSavedSelections', [
    'gnSearchManagerService', 'gnSavedSelectionConfig',
    '$http', '$q', '$rootScope', '$translate',
    function(gnSearchManagerService, gnSavedSelectionConfig,
             $http, $q, $rootScope, $translate) {

      // List of persistent selections
      // and user records in each selections
      var selections = {
        list: [],
        records: {},
        size: 0,
        refreshCounter: 1
      };

      var user = null;
      var storagePrefix = 'basket';
      var maxSize = 200;

      function SavedSelectionController(scope) {
      };

      // Load metadata record. This is needed to load
      // the title to be displayed in the panel. Only the uuid
      // is stored in saved selections.
      SavedSelectionController.prototype.loadrecords =
        function(defer, selections, allRecords) {
          selections.notFound = [];
          var ctrl = this;

          if (allRecords.length === 0) {
            selections.records = {};
            selections.size = 0;
            defer.resolve(selections);
            return;
          }

          // TODO: Handle case when there is
          // too many items in the saved selections
          gnSearchManagerService.search(
            'q?_content_type=json&buildSummary=false&from=1&to=200&' +
            'fast=index&_uuid=' +
            allRecords.join(' or ')).then(
            function(r) {
              var foundRecords = [];
              angular.forEach(r.metadata, function(md) {
                if (md) {
                  var uuid = md['geonet:info'].uuid;
                  selections.records[uuid] = md;
                  foundRecords.push(uuid);
                }
              });

              // Identify records which have been deleted
              // or that current user can't see anymore.
              // This only applies to session list.
              selections.notFound = allRecords.filter(function(i) {
                return foundRecords.indexOf(i) === -1;
              });

              // Remove not found records from the selection.
              for (var i = 0; i < selections.notFound.length; i++) {
                angular.forEach(selections.list, function(sel) {
                  if (sel.id < 0) {
                    ctrl.removeFromStore(sel, selections.notFound[i]);
                  }
                });
              }

              selections.size = allRecords.length;
              selections.refreshCounter++;

              $rootScope.$broadcast('savedSelectionsUpdate', selections);

              defer.resolve(selections);
            });
        };

      // Load the list of db saved selection + local selection
      // and then load the content of each selections
      // from db or local/session storage.
      SavedSelectionController.prototype.init =
        function(user, localOnly) {
          var defer = $q.defer(), allRecords = [], ctrl = this;
          selections.list = [];

          angular.forEach(gnSavedSelectionConfig.localList, function(s) {
            if (!(user && user.id !== undefined && s.isAnonymousOnly)) {
              selections.list.push(s);
            }
          });

          // Load user data
          // List of selections does not change often. Cache them.
          $http.get('../api/userselections', {cache: true}).then(function(r) {
            if (user != undefined) {
              selections.list = selections.list.concat(r.data);
            }
            var getUserSelections = [];
            // Load records for each selection
            angular.forEach(selections.list, function(sel) {
              // Local selections have negative identifiers
              if (sel.id > -1) {
                if (user != undefined) {
                  getUserSelections.push(
                    $http.get('../api/userselections/' +
                      sel.id + '/' + user).then(
                      function(response) {
                        sel.records = response.data;
                        allRecords = allRecords.concat(response.data);
                      }));
                }
              } else {
                if (sel.storage !== null) {
                  var key = storagePrefix + sel.name,
                    array = window[sel.storage].getItem(key);
                  var records = array != 'null' ? angular.fromJson(array) : [];
                  sel.records = records;
                  window[sel.storage].setItem(key, angular.toJson(records));
                }
                allRecords = allRecords.concat(sel.records);
              }
            });

            $q.all(getUserSelections).then(function() {
              ctrl.loadrecords(defer, selections, allRecords);
            });
          });
          return defer.promise;
        };

      SavedSelectionController.prototype.getSelections =
        function(user) {
          if (user && this.userId !== user.id) {
            this.userId = user.id;
            return this.init(this.userId);
          } else if (user === undefined) {
            this.userId = undefined;
            return this.init();
          } else {
            var defer = $q.defer();
            defer.resolve(selections);
            return defer.promise;
          }
        };

      SavedSelectionController.prototype.add =
        function(selection, user, uuid) {
          var ctrl = this;

          var tooManyItems = selection.records.length > maxSize;
          if (tooManyItems) {
            $rootScope.$broadcast('StatusUpdated', {
              msg: $translate.instant('tooManyItemsInSelection', {maxSize: maxSize}),
              timeout: 0,
              type: 'danger'});
            return;
          }

          if (selection.id > -1) {
            if (typeof selection === 'string') {
              selection = this.getSelectionId(selection);
            }

            return $http.put('../api/userselections/' +
              selection.id + '/' + this.userId, null, {
              params: {
                uuid: uuid
              }
            }).then(function(r) {
              ctrl.init(ctrl.userId);
            });
          } else {
            this.addToStore(this.getSelection(selection), uuid);
            ctrl.init(ctrl.userId, true);
          }
        };

      SavedSelectionController.prototype.remove =
        function(selection, user, uuid) {
          var ctrl = this;
          if (selection.id > -1) {
            return $http.delete('../api/userselections/' +
              selection.id + '/' + this.userId, {
              params: {
                uuid: uuid
              }
            }).then(function(r) {
              ctrl.init(ctrl.userId);
            });
          } else {
            this.removeFromStore(this.getSelection(selection), uuid);
          }
        };

      // For local selection, the storage is in synch with
      // the selection records property.
      SavedSelectionController.prototype.addToStore =
        function(selection, uuid) {
          if (selection.storage !== null) {
            var key = storagePrefix + selection.name,
              array = window[selection.storage].getItem(key);
            var records = array != 'null' ? angular.fromJson(array) : [];
            records.push(uuid);
            window[selection.storage].setItem(key, angular.toJson(records));
          }
          selection.records.push(uuid);
        };

      SavedSelectionController.prototype.removeFromStore =
        function(selection, uuid) {
          if (selection.storage !== null) {
            var key = storagePrefix + selection.name,
              array = window[selection.storage].getItem(key);
            var records = array != 'null' ? angular.fromJson(array) : [];
            var idx = records.indexOf(uuid);
            if (idx > -1) {
              records.splice(idx, 1);
              window[selection.storage].setItem(key, angular.toJson(records));
            }
          }
          if (selection.records) {
            var idx = selection.records.indexOf(uuid);
            if (idx > -1) {
              selection.records.splice(idx, 1);
              this.init(this.userId, true);
            }
          }
        };

      SavedSelectionController.prototype.getSelectionId =
        function(name) {
          for (var i = 0; i < selections.list.length; i++) {
            if (selections.list[i].name === name) {
              return selections.list[i].id;
            }
          }
        };

      // Return the selection object if an id is provided
      SavedSelectionController.prototype.getSelection =
        function(selOrId) {
          if (typeof selOrId === 'number') {
            for (var i = 0; i < selections.list.length; i++) {
              if (selections.list[i].id === selOrId) {
                return selections.list[i];
              }
            }
          } else {
            return selOrId;
          }
        };


      return {
        restrict: 'A',
        controller: ['$scope', SavedSelectionController]
      };
    }]);


  /**
   * Panel to manage user saved selection content
   */
  module.directive('gnSavedSelectionsPanel', [
    '$translate', 'gnLangs', 'gnSavedSelectionConfig', 'gpBasketService','$window',
    function($translate, gnLangs, gnSavedSelectionConfig, gpBasketService, $window) {
      function link(scope, element, attrs, controller) {
        scope.lang = gnLangs.current;
        scope.selections = null;
        scope.actions = gnSavedSelectionConfig.actions;
        scope.test='toto';
        /* Start action */
        scope.basketAction = function(sel){
          console.log(sel);
          if (window && window.geoportail) {
            console.log(window);
            if (sel==='AnonymousUserServicelist' || sel==='AnonymousUserlist'){
              scope.url = $window.location.origin + window.geoportail.homePath+'/cartes-et-donnees/mes-notifications-et-services.html';
            }
            if (sel==='DataDownloaderlist'){
              scope.url = $window.location.origin +'/sites/geoportail/geodata-donwload.html';
            }
            console.log($window.location.origin);
            $window.location.href = scope.url;
          }
        };

        scope.remove = function(selection, uuid) {
          controller.remove(selection, scope.user, uuid);
        };

        /* DETECTIN JAHIA ID */
        if (window && window.geoportail){
          console.log('panel');
          console.log(window.geoportail);
          if (window.geoportail.logged === true) {
            //console.log('window.geoportail.logged === true');
            //scope.GPuser = true
            scope.geoportailAuthPanel = "js-metadata-downloads-toggle";
          } else {
            scope.geoportailAuthPanel = "js-metadata-downloads-toggledisabled";
          }
        }

        //Comparative table between GN and Geoportail
        scope.listGeoportailBasketList = [
          {GPBasketName:'Notification', GNBasketName:'AnonymousUserlist'},
          {GPBasketName:'Download', GNBasketName:'DataDownloaderlist'},
          {GPBasketName:'Service', GNBasketName:'AnonymousUserServicelist'}
        ];
        //Request Geoportail services aiming to discover the basket of an user
        scope.requestGPbasket = function(url, GNBasketName) {
          console.log('test');
          console.log(url);
          console.log(GNBasketName);
          gpBasketService.gpbasket(url).then(function (data) {
            console.log(data);
            console.log('data console.log(scope.listGeoportailBasketList[i].GPBasketName)');
            console.log(GNBasketName);
            if (data.list){
              for (var j = 0; j < data.list.length; j++) {
                console.log(GNBasketName);
                var item = gnSavedSelectionConfig.localList.find(function (item) {
                  return item.name === GNBasketName;
                });
                console.log(item);
                if (item.records.indexOf(data.list[j].metawalId) === -1) {
                  console.log("element doesn't exist to add ");
                  console.log(item);
                  console.log(data.list[j].metawalId);
                  scope.initiateGP(item, data.list[j].metawalId);
                }
                //scope.initiateGP(item, data.list[j].metawalId);
              }
            }


          }, function (error) {
            console.log(error);
          })
        };

        //Update basket according to the result of the discovery of the Geoportail basket
        scope.initiateGP = function(selection, uuid) {
          console.log('doactionGP');
          console.log(selection);
          console.log(controller);
          console.log(uuid);
          scope.uuid = uuid;
          controller.add(selection, scope.user, scope.uuid);
          console.log('fin doactionGP');
        };


        scope.$watch('user', function(n, o) {
          if (n !== o || scope.selections === null) {
            scope.selections = null;
            controller.getSelections(scope.user).then(function(selections) {
              scope.selections = selections;
              console.log('scope.selections'+scope.selections);
              console.log(scope.selections);


              /// Add
              for (var i = 0; i < scope.listGeoportailBasketList.length ; i++) {
                var GNBasketName = scope.listGeoportailBasketList[i].GNBasketName;
                var GPBasketName = scope.listGeoportailBasketList[i].GPBasketName;
                console.log(GNBasketName + '-' + GPBasketName);
                var url = "http://jahia7.spw.test.wallonie.be/fr/sites/geoportail.manage" + scope.listGeoportailBasketList[i].GPBasketName + ".do?action=list";
                scope.requestGPbasket(url, GNBasketName);
              }
            });
          }
        });
        console.log(controller.getSelections(scope.user));
        console.log(controller);
        //console.log(sel.records);
        console.log(scope.selection);
/*
        scope.basketAction = function(){
          console.log('test basketAction')
        }

        scope.remove = function(selection, uuid) {
          controller.remove(selection, scope.user, uuid);
        };
*/
        scope.doAction = function(sel) {
          console.log('docation2');
          console.log(sel);
          /*var actionFn = scope.actions[sel.name].fn;
          if (angular.isFunction(actionFn)) {
            actionFn(sel.records, scope.selections.records);
          }*/
          if (window.geoportail.logged === true) {
            var actionApirw = scope.actions[sel.name].apirw;
            if (angular.isFunction(actionApirw)) {
              actionApirw(sel.records, scope.selections.records);
            }
            if (sel.storage === null) {
              var nbRecords = sel.records.length;
              for (var i = 0; i < nbRecords; i++) {
                controller.remove(sel, scope.user, sel.records[0]);
              }
            }
          }
        };
      }

      return {
        restrict: 'A',
        require: '^gnSavedSelections',
        templateUrl: '../../catalog/components/' +
        'common/savedselections/partials/' +
        'panel.html',
        link: link,
        scope: {
          user: '=gnSavedSelectionsPanel',
          tabsType: '=params'
        }
      };
    }]);


  /**
   * Button to add or remove item from user saved selection.
   */
  module.directive('gnSavedSelectionsAction',
    ['gnSavedSelectionConfig', '$rootScope', 'Metadata', '$http', 'gpBasketService', '$q',
      function(gnSavedSelectionConfig, $rootScope, Metadata, $http, gpBasketService,$q) {
        function link(scope, element, attrs, controller) {
          // API JS Metawal/Geoportail
          // Detect auth (GP or MW)
          // Add specific class to trigger GP auth if undefined user in MW and GP
          scope.listGeoportailBasketList = [
            {GPBasketName:'Notification', GNBasketName:'AnonymousUserlist'},
            {GPBasketName:'Download', GNBasketName:'DataDownloaderlist'},
            {GPBasketName:'Service', GNBasketName:'AnonymousUserServicelist'}
          ];

          scope.requestGPbasket = function(url, GNBasketName) {
            console.log('test');
            console.log(url);
            console.log(GNBasketName);
            gpBasketService.gpbasket(url).then(function (data) {
              console.log(data);
              console.log('data console.log(scope.listGeoportailBasketList[i].GPBasketName)');
              console.log(GNBasketName);
              for (var j = 0; j < data.list.length; j++) {
                console.log(GNBasketName);
                var item = gnSavedSelectionConfig.localList.find(function (item) {
                  return item.name === GNBasketName;
                });
                console.log(item);
                if (item.records.indexOf(data.list[j].metawalId) === -1) {
                  console.log("element doesn't exist to add ");
                  console.log(item);
                  console.log(data.list[j].metawalId);
                  scope.initiateGP(item, data.list[j].metawalId);
                }
              }

            }, function (error) {
              console.log(error);
            })
          };



          if (scope.user === undefined) {
            console.log('undefined MW user');
            scope.GNuser = false;
            /* Localhost test without window var */
           } else{
            console.log('defined MW user');
            scope.GNuser = true;
          }
          if (window && window.geoportail){
            console.log(window.geoportail);
            if (window.geoportail.logged === true) {
              console.log('window.geoportail.logged === true');
              scope.GPuser = true
              scope.geoportailAuth = "js-metadata-downloads-toggle";
              scope.addPreferredListButton = true;
             /* for (var i = 0; i < scope.listGeoportailBasketList.length ; i++) {
                var GNBasketName = scope.listGeoportailBasketList[i].GNBasketName;
                var GPBasketName = scope.listGeoportailBasketList[i].GPBasketName;
                console.log(GNBasketName + '-' + GPBasketName);
                var url = "http://jahia7.spw.test.wallonie.be/fr/sites/geoportail.manage"+ scope.listGeoportailBasketList[i].GPBasketName +".do?action=list";
                //gpBasketService.gpbasket(url);
                //console.log(gpBasketService.gpbasket(url));
                //r defer = $q.defer();
                scope.requestGPbasket(url,GNBasketName);
                gpBasketService.gpbasket(url).then(function(data) {
                  console.log(data);
                  console.log('data console.log(scope.listGeoportailBasketList[i].GPBasketName)');
                  console.log(scope.GPuser);
                  console.log(GNBasketName);
                  console.log(GPBasketName);
                  for (var j = 0; j < data.list.length; j++) {
                    //console.log(response.data.list[i].metawalId);
                    console.log(GNBasketName);
                    var item = gnSavedSelectionConfig.localList.find(function (item) {
                      return item.name === GNBasketName;
                    });
                    console.log(item);
                    if (item.records.indexOf(data.list[j].metawalId) === -1) {
                      console.log("element doesn't exist to add ");
                      console.log(item);
                      console.log(data.list[j].metawalId);
                      scope.initiateGP(item,data.list[j].metawalId);
                    }
                  }

                }, function (error) {
                  console.log(error);
                })

                scope.test = function(url){
                  return $http.get(url)
                    .then(function(response) {
                        console.log(response);
                        return response.data;
                      })
                };
                console.log(scope.test);
                for (var j = 0; j < scope.test.list.length; j++) {
                  //console.log(response.data.list[i].metawalId);
                  console.log(scope.listGeoportailBasketList[i].GNBasketName);
                  var item = gnSavedSelectionConfig.localList.find(function (item) {
                    return item.name === scope.listGeoportailBasketList[i].GNBasketName;
                  });
                  console.log(item);
                  if (item.records.indexOf(scope.test.list[j].metawalId) === -1) {
                    console.log("element doesn't exist to add ");
                    console.log(scope.test.list[j].metawalId);
                    scope.initaiteGP(item,scope.test.list[j].metawalId);
                  }
                }

                $http.get(url)
                  .then(function(response) {
                    console.log(response);
                    //console.log('gnSavedSelectionConfig avant');
                    //console.log(gnSavedSelectionConfig);
                    for (var j = 0; j < response.data.list.length; j++) {
                      //console.log(response.data.list[i].metawalId);
                      console.log(GNBasketName);
                      var item = gnSavedSelectionConfig.localList.find(function (item) {
                        return item.name === GNBasketName;
                      });
                      console.log(item);
                      if (item.records.indexOf(response.data.list[j].metawalId) === -1) {
                        console.log("element doesn't exist to add ");
                        console.log(response.data.list[j].metawalId);
                        scope.initiateGP(item,response.data.list[j].metawalId);
                      }
                    }
                    //console.log('gnSavedSelectionConfig après');
                    //console.log(gnSavedSelectionConfig);
                  });
              }*/

            } else {
              console.log('window.geoportail.logged === false');
              scope.GPuser = false
              scope.geoportailAuth = "js-metadata-downloads-toggledisabled";
              scope.addPreferredListButton = false;
            }
          }
          // END API JS Metawal/Geoportail
          // START API JS Geoportail - TEST localhost
         // scope.addPreferredListButton = true;
          // END API JS Geoportail - TEST localhost


          scope.doaction = function(selection) {
            console.log('doaction1');
            if (selection.records.indexOf(scope.uuid) > -1) {
              controller.remove(selection, scope.user, scope.uuid);
            } else {
              controller.add(selection, scope.user, scope.uuid);
            }
          };


          scope.selectionsWithRecord = [];
          scope.selections = {};
          scope.uuid = scope.record['geonet:info'].uuid;

          scope.actions = gnSavedSelectionConfig.actions;

          $rootScope.$on('savedSelectionsUpdate', function(e, n, o) {
            scope.selections = n;
            // Check in which selection this record is in
            scope.selectionsWithRecord = [];
            for (var i = 0; i < scope.selections.list.length; i++) {
              var s = scope.selections.list[i];
              if (s.records) {
                for (var j = 0; j < s.records.length; j++) {
                  if (s.records[j] === scope.uuid) {
                    scope.selectionsWithRecord.push(s.id);
                    break;
                  }
                }
              }
            }
          });



          controller.getSelections(scope.user).then(function(selections) {
            scope.selections = selections;
          });
          ///Add url to thematic map
          // (protocol=WWW:LINK-1.0-http--link and function=browing)
          ///TO BE COMPLETED - add function
          scope.md = new Metadata(scope.record);
          for (var i = scope.md.getLinksByType().length - 1; i >= 0; i--) {
            scope.mdurldisabled = true;
            if (scope.md.getLinksByType()[i].protocol ===
              'WWW:LINK-1.0-http--link') {
              scope.mdurl = scope. md.getLinksByType()[i].url;
              if (scope.mdurl === '') {
                scope.mdurldisabled = true;
              }
              scope.mdurldisabled = false;
            }
          }

          scope.disable = function(selection, elem) {
            var md = new Metadata(elem);
            if (selection.name === 'DataDownloaderlist') {
              if (elem.keyword.indexOf(
                'PanierTelechargementGeoportail') > -1) {
                return false;
              } else {
                return true}
            }
            else if (selection.name === 'MapLayerlist') {
              //var md = new Metadata(elem);
              if (md.getLinksByType('ESRI:REST').length > 0 ||
                md.getLinksByType('OGC:WMS').length > 0) {
                return false;
              } else {
                return true;
              }
            }
            else {
              return false;
            }
          };

          scope.doaction = function(selection) {
            //console.log('selection=');
            //console.log(selection);
            //console.log(scope.user);
            //console.log(scope.uuid);
            //scope.action = null;
            if (window.geoportail){
            if (window.geoportail.logged === true) {
              if (selection.records.indexOf(scope.uuid) > -1) {
                controller.remove(selection, scope.user, scope.uuid);
                scope.action = 'remove';
                scope.updateGPBasket(selection, scope.uuid, scope.action);
              } else {
                controller.add(selection, scope.user, scope.uuid);
                scope.action = 'add';
                scope.updateGPBasket(selection, scope.uuid, scope.action);
              }
            }
            else if (selection.name === "AnonymousUserlist"){
              if (scope.user != undefined) {
                if (selection.records.indexOf(scope.uuid) > -1) {
                  controller.remove(selection, scope.user, scope.uuid);
                  scope.action = 'remove';
                  scope.updateGPBasket(selection, scope.uuid, scope.action);
                } else {
                  controller.add(selection, scope.user, scope.uuid);
                  scope.action = 'add';
                  scope.updateGPBasket(selection, scope.uuid, scope.action);
                }
              }
            }else if (selection.name === "MapLayerlist"){
              if (selection.records.indexOf(scope.uuid) > -1) {
                controller.remove(selection, scope.user, scope.uuid);
                scope.action = 'remove';
                scope.updateGPBasket(selection, scope.uuid, scope.action);
              } else {
                controller.add(selection, scope.user, scope.uuid);
                scope.action = 'add';
                scope.updateGPBasket(selection, scope.uuid, scope.action);
              }
            }else {}
          }
          };

          scope.initiateGP = function(selection, uuid) {
            console.log('doactionGP');
            console.log(selection);
            console.log(controller);
            console.log(uuid);
            scope.uuid = uuid;
            controller.add(selection, scope.user, scope.uuid);
            console.log('fin doactionGP');
          };

          scope.updateGPBasket = function(selection, uuid, action) {
           //console.log('updateGPBasket')
            var item = scope.listGeoportailBasketList.find(function (item) {
              return item.GNBasketName === selection.name;
            });
            var url = "http://jahia7.spw.test.wallonie.be/fr/sites/geoportail.manage"+ item.GPBasketName +".do";
            var data = $.param({
              metawalId: uuid,
              action: action
            });
            var config = {
              headers : {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'Accept':'application/json, text/javascript, */*; q=0.01'
              }
            }
            $http.post(url, data, config)
              .then(function(response) {
                console.log(response);
              });
          };

          /*scope.add = function(selection) {
           console.log('add');
            controller.add(selection, scope.user, scope.uuid);
          };

          scope.remove = function(selection) {
           console.log('remove');
            controller.remove(selection, scope.user, scope.uuid);
          };*/


          function check(selection, canBeAdded) {
            // Authenticated user can't use local anymous selections
            if (scope.user && scope.user.id !== undefined &&
              selection.isAnonymousOnly === true) {
              return false;
            }

            // Check if selection has an advanced filter
            var selConfig = gnSavedSelectionConfig.actions[selection.name];
            var isValidRecord = false;
            if (selConfig && selConfig.filterFn &&
              angular.isFunction(selConfig.filterFn)) {
              isValidRecord = selConfig.filterFn(scope.record);
            } else {
              isValidRecord = true;
            }

            if (angular.isArray(selection.records) &&
              isValidRecord && canBeAdded) {
              // Check if record already in current selection
              return selection.records.indexOf(scope.uuid) === -1;
            } else if (angular.isArray(selection.records) &&
              isValidRecord && canBeAdded === false) {
              // Check if record not already in current selection
              return selection.records.indexOf(scope.uuid) !== -1;
            } else {
              return false;
            }
          }

          function checkStatus(selection, addedOrRemoved) {
            if (selection) {
              return check(selection, addedOrRemoved);
            } else {
              var result = false;
              if (scope.selections.list === undefined) {
                return false;
              }
              for (var i = 0; i < scope.selections.list.length; i++) {
                if (check(scope.selections.list[i], addedOrRemoved)) {
                  result = true;
                }
              }
              return result;
            }
          }

          scope.canBeAdded = function(selection) {
            return checkStatus(selection, true);
          };
          scope.canBeRemoved = function(selection) {
            return checkStatus(selection, false);
          };

        }
        return {
          restrict: 'A',
          templateUrl: '../../catalog/components/common/' +
          'savedselections/partials/action.html',
          require: '^gnSavedSelections',
          link: link,
          scope: {
            selection: '@gnSavedSelectionsAction',
            record: '=',
            user: '=',
            lang: '='
          }
        };
      }]);
})();
