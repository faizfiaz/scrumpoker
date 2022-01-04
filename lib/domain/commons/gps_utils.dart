import 'package:geolocator/geolocator.dart';

// ignore: avoid_classes_with_only_static_members
class GPSUtils {
  static Future<Map<Position?, ErrorGPSHandler?>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.value(
          {null: ErrorGPSHandler(0, "Location services are disabled.")});
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.value(
            {null: ErrorGPSHandler(1, "Location permissions are denied")});
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.value({
        null: ErrorGPSHandler(2,
            "Location permissions are permanently denied, we cannot request permissions.")
      });
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final position = await Geolocator.getCurrentPosition();
    return Future.value({position: null});
  }
}

class ErrorGPSHandler {
  // 0 : GPS Disabled
  // 1 : Permission Denied
  // 2 : Permission Denied Forever
  // 3 : Cannot get location
  int errorService;
  String message;

  ErrorGPSHandler(this.errorService, this.message);
}
