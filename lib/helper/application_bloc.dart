import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:women_safety/data/model/response/geometry.dart';
import 'package:women_safety/data/model/response/location.dart';
import 'package:women_safety/data/model/response/place.dart';
import 'package:women_safety/data/model/response/place_search.dart';
import 'package:women_safety/services/geolocator_service.dart';
import 'package:women_safety/services/marker_service.dart';
import 'package:women_safety/services/places_service.dart';

class ApplicationBloc with ChangeNotifier {
  final geolocatorService = GeolocatorService();
  final placesService = PlacesService();
  final markerService = MarkerService();

  // Variables
  Position? currentLocation;
  List<PlaceSearch>? searchResults;
  StreamController<Place> selectedLocation = StreamController<Place>.broadcast();
  StreamController<LatLngBounds> bounds = StreamController<LatLngBounds>.broadcast();
  Place? selectedLocationStatic;
  String? placeType;
  List<Marker> markers = <Marker>[];

  ApplicationBloc() {
    setCurrentLocation();
  }

  Place? get event => null;

  setCurrentLocation() async {
    currentLocation = await geolocatorService.getCurrentLocation();
    selectedLocationStatic = Place(
        geometry: Geometry(location: Location(lat: currentLocation!.latitude, lng: currentLocation!.longitude)),
        name: null,
        vicinity: "Bamenda");
    notifyListeners();
  }

  searchPLaces(String searchTerm) async {
   // searchResults = await placesService.getAutoComplete(searchTerm) as List<PlaceSearch>;
    notifyListeners();
  }

  setSelectedLocation(String? placeId) async {
    // var sLocation = await placesService.getPlace(placeId);
    // selectedLocation.add(await placesService.getPlace(placeId));
    // selectedLocationStatic = sLocation;
    searchResults = null;
    notifyListeners();
  }

  clearSelectedLocation() {
    selectedLocation.add(event!);
    selectedLocationStatic = null;
    searchResults = null;
    placeType = null;
    notifyListeners();
  }

  togglePlaceType(String value, bool selected) async {
    if (selected) {
      placeType = value;
    } else {
      placeType = null;
    }

    if (placeType != null) {
      openUrl('https://www.google.com/maps/search/$value/@${currentLocation!.latitude},${currentLocation!.longitude}, 12z');
    }

    notifyListeners();
  }

  openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    selectedLocation.close();
    super.dispose();
  }

  int selectMenuIndex = 0;

  changeMenuIndex(int value) {
    selectMenuIndex = value;
    notifyListeners();
  }

  resetManu() {
    selectMenuIndex = 0;
  }
}
