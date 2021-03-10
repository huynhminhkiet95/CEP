import 'dart:convert';

import 'package:CEPmobile/models/googlemap/geocoded_waypoint.dart';
import 'package:CEPmobile/models/googlemap/route.dart';

class MapInformation {
  List<GeocodedWaypoint> geocodedWaypoints;
  List<Route> routes;
  String status;

  MapInformation({this.status, this.geocodedWaypoints, this.routes});

  factory MapInformation.fromJson(Map<String, dynamic> jsonResult) {
    var routes = new List<Route>();
    var geocodedWaypoints = new List<GeocodedWaypoint>();

    var jsonRoutes = json.decode(jsonResult["routes"]) as List;
    if (jsonRoutes.length > 0) {
      var routesJson = json
          .decode(jsonResult["routes"])
          .cast<Map<String, dynamic>>() as List;
      if (routesJson.length > 0) {
        routes = routesJson
            .map<Route>((jsonItem) => Route.fromJson(jsonItem))
            .toList();
      }
    }

    var geocodedWaypointsJson = json
        .decode(jsonResult["geocoded_waypoints"])
        .cast<Map<String, dynamic>>() as List;
    if (geocodedWaypointsJson.length > 0) {
      geocodedWaypoints = geocodedWaypointsJson
          .map<GeocodedWaypoint>(
              (jsonItem) => GeocodedWaypoint.fromJson(jsonItem))
          .toList();
    }

    return MapInformation(
      geocodedWaypoints: geocodedWaypoints,
      routes: routes,
      status: jsonResult["status"] as String,
    );
  }
}
