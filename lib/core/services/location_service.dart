import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<bool> requestPermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  Future<Position?> getCurrentPosition() async {
    final hasPermission = await requestPermission();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  Future<bool> isWithinRadius({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
    required double radiusKm,
  }) async {
    final distance = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
    return distance <= radiusKm * 1000;
  }
}
