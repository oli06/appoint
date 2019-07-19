import 'dart:math' show cos, sqrt, asin;

class DistanceUtil {
  static double calculateDistanceBetweenCoordinates(
      double lat1, double lon1, double lat2, double lon2) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) {
      return double.infinity;
    }

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
