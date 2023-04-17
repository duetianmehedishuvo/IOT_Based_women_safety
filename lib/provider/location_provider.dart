import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:women_safety/util/helper.dart';
import 'package:women_safety/widgets/snackbar_message.dart';

class LocationProvider with ChangeNotifier {
  double distanceInMetersForStartRange = 0.0;
  double distanceInMetersForEndRange = 0.0;
  final DatabaseReference messagesRef = FirebaseDatabase.instance.ref();

  calculateDistance(bool isFirstTime) {
    distanceInMetersForStartRange = Geolocator.distanceBetween(startRangeLat, startRangeLon, childLat, childLon);
    distanceInMetersForEndRange = Geolocator.distanceBetween(endRangeLat, endRangeLon, childLat, childLon);
    if (!isFirstTime) notifyListeners();
  }

  String googleApiKey = 'AIzaSyDJu-xdHXPpyEE-MhyXUdwJIXRBO4pY2b8';
  bool isDebugMode = true;

  getCurrentUserLocation() async {
    final api = GoogleGeocodingApi(googleApiKey, isLogged: isDebugMode);
    status = 0;
    locationLists.clear();
    locationLists = [];
    final reversedSearchResults = await api.reverse('$childLat,$childLon', language: 'en');
    for (var element in reversedSearchResults.results) {
      if (isNumeric(element.formattedAddress.substring(0, 1)) ||
          element.formattedAddress[0] == '+' ||
          element.formattedAddress.substring(0, 7).toLowerCase() == 'unnamed' ||
          element.formattedAddress.isEmpty) {
      } else {
        locationLists.add(element.formattedAddress);
      }
    }
    notifyListeners();
  }

  double startRangeLat = 0.000000;
  double startRangeLon = 0.000000;
  double endRangeLat = 0.000000;
  double endRangeLon = 0.000000;
  double childLat = 0.000000;
  double childLon = 0.000000;
  String startLocationName = '';
  String endLocationName = '';

  int status = 0;
  List<String> locationLists = [];

  initializeRange(startRangeLat, startRangeLon, endRangeLat, endRangeLon, childLat, childLon, startLocationName, endLocationName) {
    if (this.childLat == childLat && this.childLon == childLon) {
    } else {
      this.startRangeLat = startRangeLat;
      this.startRangeLon = startRangeLon;
      this.endRangeLat = endRangeLat;
      this.endRangeLon = endRangeLon;
      this.childLat = childLat;
      this.childLon = childLon;
      this.startLocationName = startLocationName;
      this.endLocationName = endLocationName;
      calculateDistance(true);
      getCurrentUserLocation();
    }
  }

  bool isLoading = false;
  double userSelectLat = 0.00;
  double userSelectLon = 0.00;
  List<String> changeUserLocation = [];

  changeLocation(LatLng latLng, bool isFirstTime) {
    userSelectLat = latLng.latitude;
    userSelectLon = latLng.longitude;
    if (!isFirstTime) notifyListeners();
  }

  Future<bool> saveRangeData(bool isFromStartRange) async {
    isLoading = true;
    changeUserLocation.clear();
    changeUserLocation = [];
    notifyListeners();
    final api = GoogleGeocodingApi(googleApiKey, isLogged: isDebugMode);

    final reversedSearchResults = await api.reverse('$userSelectLat,$userSelectLon', language: 'en');
    for (var element in reversedSearchResults.results) {
      if (isNumeric(element.formattedAddress.substring(0, 1)) ||
          element.formattedAddress[0] == '+' ||
          element.formattedAddress.substring(0, 7).toLowerCase() == 'unnamed' ||
          element.formattedAddress.isEmpty) {
      } else {
        changeUserLocation.add(element.formattedAddress);
      }
    }

    if (isFromStartRange) {
      messagesRef.child('Location').update({
        "start_range_lat": userSelectLat,
        "stat_range_lon": userSelectLon,
        "stat_location_name": changeUserLocation.isEmpty ? "Not Found" : changeUserLocation[0]
      });
      startRangeLat = userSelectLat;
      startRangeLon = userSelectLon;
      startLocationName = changeUserLocation.isEmpty ? "Not Found" : changeUserLocation[0];
    } else {
      messagesRef.child('Location').update({
        "end_range_lat": userSelectLat,
        "end_range_lon": userSelectLon,
        "end_location_name": changeUserLocation.isEmpty ? "Not Found" : changeUserLocation[0]
      });
      endRangeLat = userSelectLat;
      endRangeLon = userSelectLon;
      endLocationName = changeUserLocation.isEmpty ? "Not Found" : changeUserLocation[0];
    }

    calculateDistance(false);
    isLoading = false;
    notifyListeners();
    showMessage(message: 'Successfully', isError: false);
    return true;
  }

  getCurrentUserLocationByPosition() async {
    final api = GoogleGeocodingApi(googleApiKey, isLogged: isDebugMode);
    status = 0;
    changeUserLocation.clear();
    changeUserLocation = [];
    final reversedSearchResults = await api.reverse('$userSelectLat,$userSelectLon', language: 'en');
    for (var element in reversedSearchResults.results) {
      if (isNumeric(element.formattedAddress.substring(0, 1)) ||
          element.formattedAddress[0] == '+' ||
          element.formattedAddress.substring(0, 7).toLowerCase() == 'unnamed' ||
          element.formattedAddress.isEmpty) {
      } else {
        changeUserLocation.add(element.formattedAddress);
      }
    }
    notifyListeners();
  }
}
