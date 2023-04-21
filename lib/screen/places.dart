import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_config/flutter_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:women_safety/helper/application_bloc.dart';
import 'package:women_safety/data/model/response/place.dart';
import 'package:women_safety/shared/appbar.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  late StreamSubscription locationSubscription;
  late StreamSubscription boundsSubscription;
  final _locationController = TextEditingController();

  _checkStatus() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
    } else if (status.isDenied) {
      Map<Permission, PermissionStatus> status = await [
        Permission.location,
      ].request();
    }
    if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  void initState() {
    _checkStatus();
    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);

    // listen for a selected location
    locationSubscription = applicationBloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        _locationController.text = place.name!;
        _goToPlace(place);
      } else {
        _locationController.text = "";
      }
    });

    boundsSubscription = applicationBloc.bounds.stream.listen((bounds) async {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
    });

    super.initState();
  }

  @override
  void dispose() {
    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();
    boundsSubscription.cancel();
    locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      appBar: SafeHervenAppBar("Find Nearby Places", isHome: false),
      body: ListView(children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Find Nearest Place',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 5.0,
                  children: [
                    FilterChip(
                      label: const Text('Hospital'),
                      onSelected: (val) => applicationBloc.togglePlaceType('hospital', val),
                      selected: applicationBloc.placeType == 'hospital',
                      selectedColor: Colors.purple,
                    ),
                    FilterChip(
                      label: const Text('Police Station'),
                      onSelected: (val) => applicationBloc.togglePlaceType('police', val),
                      selected: applicationBloc.placeType == 'police',
                      selectedColor: Colors.purple,
                    ),
                    FilterChip(
                      label: const Text('Church'),
                      onSelected: (val) => applicationBloc.togglePlaceType('church', val),
                      selected: applicationBloc.placeType == 'church',
                      selectedColor: Colors.purple,
                    ),
                    FilterChip(
                      label: const Text('Mosque'),
                      onSelected: (val) => applicationBloc.togglePlaceType('mosque', val),
                      selected: applicationBloc.placeType == 'mosque',
                      selectedColor: Colors.purple,
                    ),
                    FilterChip(
                      label: const Text('Pharmacy'),
                      onSelected: (val) => applicationBloc.togglePlaceType('pharmacy', val),
                      selected: applicationBloc.placeType == 'pharmacy',
                      selectedColor: Colors.purple,
                    ),
                    FilterChip(
                      label: const Text('Travel Agency'),
                      onSelected: (val) => applicationBloc.togglePlaceType('travel_agency', val),
                      selected: applicationBloc.placeType == 'travel_agency',
                      selectedColor: Colors.purple,
                    ),
                    FilterChip(
                      label: const Text('Lawyer'),
                      onSelected: (val) => applicationBloc.togglePlaceType('lawyer', val),
                      selected: applicationBloc.placeType == 'lawyer',
                      selectedColor: Colors.purple,
                    ),
                    FilterChip(
                      label: const Text('ATM'),
                      onSelected: (val) => applicationBloc.togglePlaceType('atm', val),
                      selected: applicationBloc.placeType == 'atm',
                      selectedColor: Colors.purple,
                    ),
                    FilterChip(
                      label: const Text('Bank'),
                      onSelected: (val) => applicationBloc.togglePlaceType('bank', val),
                      selected: applicationBloc.placeType == 'bank',
                      selectedColor: Colors.purple,
                    ),
                    FilterChip(
                      label: const Text('Doctor'),
                      onSelected: (val) => applicationBloc.togglePlaceType('doctor', val),
                      selected: applicationBloc.placeType == 'doctor',
                      selectedColor: Colors.purple,
                    ),
                    FilterChip(
                      label: const Text('University'),
                      onSelected: (val) => applicationBloc.togglePlaceType('university', val),
                      selected: applicationBloc.placeType == 'university',
                      selectedColor: Colors.purple,
                    ),
                  ],
                ),
              ),
            ]),
    );
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(place.geometry.location.lat, place.geometry.location.lng), zoom: 14)));
  }
}
