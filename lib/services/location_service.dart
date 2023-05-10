import 'package:dorx/services/services.dart';


class LocationService {
  Future<void> openInGoogleMaps(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    await StorageServices().launchTheThing(
      googleUrl,
    );
  }
}
