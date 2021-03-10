import 'dart:convert';

class Route {
  List<Bound> bounds;
  String copyrights;
  List<Leg> legs;
  String summary;

  Route({this.bounds, this.copyrights, this.legs, this.summary});

  factory Route.fromJson(Map<String, dynamic> jsonResult) {
    var legs = new List<Leg>();
    var bounds = new List<Bound>();

    var legsJson = json.decode(jsonResult["legs"]).cast<Map<String, dynamic>>() as List;
    if (legsJson.length > 0) {
      legs = legsJson.map<Leg>((jsonItem) => Leg.fromJson(jsonItem)).toList();
    }

    var boundsJson = json.decode(jsonResult["bounds"]).cast<Map<String, dynamic>>() as List;
    if (boundsJson.length > 0) {
      bounds = boundsJson.map<Bound>((jsonItem) => Bound.fromJson(jsonItem)).toList();
    }
    return Route(
        bounds: bounds,
        legs: legs,
        summary: jsonResult['summary'] as String,
        copyrights: jsonResult['copyrights'] as String);
  }
}

class Bound {
  Position southwest;
  Position northeast;

  Bound({this.southwest, this.northeast});

  factory Bound.fromJson(Map<String, dynamic> json) {
    return Bound(
      southwest: Position.fromJson(json["southwest"]),
      northeast: Position.fromJson(json["northeast"]),
    );
  }
}

class OverviewPolyline {
  String points;

  OverviewPolyline({this.points});

  factory OverviewPolyline.fromJson(Map<String, dynamic> json) {
    return OverviewPolyline(points: json['points'] as String);
  }
}

class Polyline {
  String points;

  Polyline({this.points});

  factory Polyline.fromJson(Map<String, dynamic> json) {
    return Polyline(
      points: json['points'] as String,
    );
  }
}

class Leg {
  Distance distance;
  Duration duration;
  String endAddress;
  String startAddress;
  Position startLocation;
  Position endLocation;
  List<Step> steps;

  Leg(
      {this.distance,
      this.duration,
      this.startAddress,
      this.endAddress,
      this.startLocation,
      this.endLocation,
      this.steps});

  factory Leg.fromJson(Map<String, dynamic> jsonResult) {
    List<Step> steps = new List();
    var stepsJson = json.decode(jsonResult["steps"]).cast<Map<String, dynamic>>() as List;
    if (stepsJson.length > 0) {
      steps = stepsJson.map<Step>((jsonItem) => Step.fromJson(jsonItem)).toList();
    }

    return Leg(
        distance: Distance.fromJson(jsonResult["distance"]),
        duration: Duration.fromJson(jsonResult["duration"]),
        startLocation: Position.fromJson(jsonResult["start_location"]),
        endLocation: Position.fromJson(jsonResult["start_location"]),
        steps: steps,
        endAddress: jsonResult['end_address'] as String,
        startAddress: jsonResult['start_address'] as String);
  }
}

class Step {
  Distance distance;
  Duration duration;
  Position startLocation;
  Position endLocation;
  String htmlInstructions;
  Polyline polyline;
  String travelMode;

  Step(
      {this.distance,
      this.duration,
      this.startLocation,
      this.endLocation,
      this.htmlInstructions,
      this.polyline,
      this.travelMode});

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
        distance: Distance.fromJson(json["distance"]),
        duration: Duration.fromJson(json["duration"]),
        startLocation: Position.fromJson(json["start_location"]),
        endLocation: Position.fromJson(json["start_location"]),
        travelMode: json['travel_mode'] as String,
        htmlInstructions: json['html_instructions'] as String,
        polyline: Polyline.fromJson(json["polyline"]));
  }
}

class Distance {
  String text;
  int value;

  Distance({this.text, this.value});

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(
      text: json['text'] as String,
      value: int.parse(json['value']),
    );
  }
}

class Duration {
  String text;
  int value;

  Duration({this.text, this.value});

  factory Duration.fromJson(Map<String, dynamic> json) {
    return Duration(
      text: json['text'] as String,
      value: int.parse(json['value']),
    );
  }
}

class Position {
  double lat;
  double lng;

  Position({this.lat, this.lng});

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      lat: double.parse(json["lat"]),
      lng: double.parse(json["lng"]),
    );
  }
}
