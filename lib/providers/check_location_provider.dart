import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;

class LocationCheckProvider extends ChangeNotifier {
  bool _checkSnackBar = false;
  bool get showSnackBar => _checkSnackBar;
  bool _isInsideLocation = false; 
  bool get isInsideLocation =>
      _isInsideLocation; 

  final List<LatLng> polygonsTDTU = const [
    LatLng(10.73343784161409, 106.69639213882168),
    LatLng(10.733140054627112, 106.69978513319467),
    LatLng(10.730731395097495, 106.70003189642024),
    LatLng(10.73030974595168, 106.69736578067798)
  ];

  void updateIsInsideLocation(LatLng location) {
    List<map_tool.LatLng> convertPolygonsPoints = polygonsTDTU
        .map((e) => map_tool.LatLng(e.latitude, e.longitude))
        .toList();
    _isInsideLocation = map_tool.PolygonUtil.containsLocation(
        map_tool.LatLng(location.latitude, location.longitude),
        convertPolygonsPoints,
        false);
    notifyListeners(); // Thông báo sự thay đổi của biến isInsideLocation
  }

  void setShowSnackBar(bool check) {
    _checkSnackBar = check;
    notifyListeners();
  }
}
