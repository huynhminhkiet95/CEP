class SingleSimpleTripMapInfo {
  String _placeType;
  double _lat;
  double _lon;
  String _tel;
  String _placeName;
  String _placeAddress;

  String get getPlaceAddress => _placeAddress;

  set setPlaceAddress(String value) => _placeAddress = value;

  String get getPlaceType => _placeType;

  set setPlaceType(String value) => _placeType = value;

  String get getTel => _tel;

  set setTel(String value) => _tel = value;

  String get getPlaceName => _placeName;

  set setPlaceName(String value) => _placeName = value;

  double get getLat => _lat;

  set setLat(double value) => _lat = value;

  double get getLon => _lon;

  set setLon(double value) => _lon = value;

  SingleSimpleTripMapInfo();
}
