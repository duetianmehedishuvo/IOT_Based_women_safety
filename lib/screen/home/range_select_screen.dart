import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:women_safety/provider/location_provider.dart';
import 'package:women_safety/util/helper.dart';
import 'package:women_safety/util/theme/app_colors.dart';
import 'package:women_safety/widgets/custom_app_bar.dart';
import 'package:women_safety/widgets/custom_button.dart';

class RangeSelectScreen extends StatefulWidget {
  final bool hasFromStartRange;

  const RangeSelectScreen({this.hasFromStartRange = false, super.key});

  @override
  State<RangeSelectScreen> createState() => _RangeSelectScreenState();
}

class _RangeSelectScreenState extends State<RangeSelectScreen> {
  CameraPosition initialCameraPosition =
      const CameraPosition(target: LatLng(37.42796133580664, -122.085749655962), zoom: 12, tilt: 80, bearing: 30);
  GoogleMapController? mapController;
  late LatLng latLng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.hasFromStartRange) {
      latLng = LatLng(Provider.of<LocationProvider>(context, listen: false).startRangeLat,
          Provider.of<LocationProvider>(context, listen: false).startRangeLon);
    } else {
      latLng = LatLng(Provider.of<LocationProvider>(context, listen: false).endRangeLat,
          Provider.of<LocationProvider>(context, listen: false).endRangeLon);
    }
    Provider.of<LocationProvider>(context, listen: false).changeLocation(latLng, true);
    initialCameraPosition = CameraPosition(target: latLng, zoom: 15, tilt: 80, bearing: 30);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "${widget.hasFromStartRange ? "Start" : "End"} Range Select", borderRadius: 0),
      body: AutofillGroup(
        child: Consumer<LocationProvider>(
            builder: (context, locationProvider, child) => ModalProgressHUD(
                  inAsyncCall: locationProvider.isLoading,
                  progressIndicator: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorPrimary)),
                  child: GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Stack(
                      children: [
                        GoogleMap(
                          mapType: MapType.hybrid,
                          myLocationEnabled: true,
                          compassEnabled: true,
                          tiltGesturesEnabled: true,
                          zoomControlsEnabled: true,
                          initialCameraPosition: initialCameraPosition,
                          onMapCreated: (GoogleMapController? controller) {
                            mapController = controller;
                          },
                          onCameraMove: (position) {
                            locationProvider.changeLocation(position.target, false);
                          },
                        ),
                        Center(child: Image.asset("assets/images/marker.png")),
                        Positioned(
                            bottom: 40,
                            left: 60,
                            right: 80,
                            child: CustomButton(
                              btnTxt: 'Save',
                              onTap: () {
                                locationProvider.saveRangeData(widget.hasFromStartRange).then((value) {
                                  if (value) {
                                    Helper.back();
                                  }
                                });
                              },
                            )),
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}
