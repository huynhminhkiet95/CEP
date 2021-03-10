import 'package:android_intent/android_intent.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:platform/platform.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapService {
  final String googleApiKey = "AIzaSyCztTotaR8vxfto_Ao1AQcX7Cpsv3pnSu0";

  //https://maps.googleapis.com/maps/api/directions/" + output + "?" + parameters+"&key="+key;
  static const String urlDirection =
      "https://maps.googleapis.com/maps/api/directions/%s?%s&key=%s";


  String getUrlDirections(
      LatLng origin, LatLng destination, bool sensor, String output) {
    var strOrigin = "origin=" +
        origin.latitude.toString() +
        "," +
        origin.longitude.toString();
    var strDestination = "destination=" +
        destination.latitude.toString() +
        "," +
        destination.longitude.toString();
    var strSensor = "sensor=" + sensor.toString();
    var parameters = strOrigin + "&" + strDestination + "&" + strSensor;
    var url = sprintf(urlDirection, [output, parameters, googleApiKey]);

    return url;
  }

  Future<http.Response> getDirectionsInformation(
      LatLng origin, LatLng destination, bool sensor, String output) async {
    var result =
        await http.get(getUrlDirections(origin, destination, sensor, output));
    return result;
  }

  static void goMap(double latorigin, double lonorigin, double latdestination,
      double londestination) async {
    String origin = "$latorigin,$lonorigin"; // lat,long like 123.34,68.56
    String destination = "$latdestination,$londestination";
    if (new LocalPlatform().isAndroid) {
      final AndroidIntent intent = new AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull(
              "https://www.google.com/maps/dir/?api=1&travelmode=driving&origin="+origin+"&destination="+destination+""),
          package: 'com.google.android.apps.maps');
      intent.launch();
    } else {
      String url = "https://www.google.com/maps/dir/?api=1&origin=" +
          origin +
          "&destination=" +
          destination +
          "&travelmode=driving&dir_action=navigate";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  static void goMapWithMarker(double latorigin, double lonorigin) async {
    String origin = "$latorigin,$lonorigin";
    if (new LocalPlatform().isAndroid) {
      final AndroidIntent intent = new AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull(
              "https://www.google.com/maps/search/?api=1&query="+origin),
          package: 'com.google.android.apps.maps');
      intent.launch();
    } else {
      String url = "https://www.google.com/maps/search/?api=1&query="+origin;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }
}
