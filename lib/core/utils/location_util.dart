import 'dart:math' as math;

class LocationUtil {
  static double calculateBearing(
      double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    final lat1 = startLatitude * math.pi / 180;
    final lat2 = endLatitude * math.pi / 180;
    final deltaLon = (endLongitude - startLongitude) * math.pi / 180;

    final y = math.sin(deltaLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(deltaLon);

    final bearing = math.atan2(y, x);
    return (bearing * 180 / math.pi + 360) % 360;
  }
}
