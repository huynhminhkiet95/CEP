class GeocodedWaypoint {
  String geocoderStatus;
  String placeId;
  List<String> types;

  GeocodedWaypoint({this.geocoderStatus, this.placeId, this.types});

  factory GeocodedWaypoint.fromJson(Map<String, dynamic> json) {
    return GeocodedWaypoint(
      geocoderStatus: json["geocoder_status"] as String,
      placeId: json["place_id"] as String,
      types: new List<String>.from(json['types']),
    );
  }
}
