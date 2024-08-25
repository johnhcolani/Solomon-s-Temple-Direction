import 'package:geolocator/geolocator.dart';

import '../../../../core/utils/location_util.dart';

class LocationDataSource {
  Future<double> getDirectionToTemple(double latitude, double longitude) async {
    const templeLatitude = 31.7784;
    const templeLongitude = 35.2353;

    return LocationUtil.calculateBearing(latitude, longitude, templeLatitude, templeLongitude);
  }

  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
