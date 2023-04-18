import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:women_safety/helper/message_dao.dart';
import 'package:women_safety/provider/location_provider.dart';
import 'package:women_safety/screen/home/range_select_screen.dart';
import 'package:women_safety/screen/home_screen.dart';
import 'package:women_safety/util/helper.dart';
import 'package:women_safety/util/theme/app_colors.dart';
import 'package:women_safety/util/theme/text.styles.dart';
import 'package:women_safety/widgets/custom_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMART Child Care'),
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          children: [
            StreamBuilder(
              stream: MessageDao.messagesRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                LatLng latLng = LatLng(double.parse(snapshot.data!.snapshot.child('Location').children.elementAt(7).value.toString()),
                    double.parse(snapshot.data!.snapshot.child('Location').children.elementAt(2).value.toString()));
                locationProvider.initializeRange(
                  double.parse(snapshot.data!.snapshot.child('Location').children.elementAt(3).value.toString()),
                  double.parse(snapshot.data!.snapshot.child('Location').children.elementAt(1).value.toString()),
                  double.parse(snapshot.data!.snapshot.child('Location').children.elementAt(4).value.toString()),
                  double.parse(snapshot.data!.snapshot.child('Location').children.elementAt(0).value.toString()),
                  latLng.latitude,
                  latLng.longitude,
                  snapshot.data!.snapshot.child('Location').children.elementAt(6).value.toString(),
                  snapshot.data!.snapshot.child('Location').children.elementAt(5).value.toString(),
                );

                return Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: colorPrimary.withOpacity(.2), blurRadius: 3.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                      ],
                      border: Border.all(color: colorPrimary, width: 4)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Helper.toScreen(const RangeSelectScreen(hasFromStartRange: true));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(.2),
                                          blurRadius: 10.0,
                                          spreadRadius: 3.0,
                                          offset: const Offset(0.0, 0.0))
                                    ],
                                    borderRadius: BorderRadius.circular(4)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Start Range', style: sfProStyle500Medium.copyWith(fontSize: 15)),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.edit, color: Colors.green, size: 17)
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(snapshot.data!.snapshot.child('Location').children.elementAt(6).value.toString(),
                                        style: sfProStyle600SemiBold.copyWith(fontSize: 12), textAlign: TextAlign.center),
                                    const SizedBox(height: 5),
                                    Text(
                                        '${locationProvider.startRangeLat.toStringAsFixed(5)}, ${locationProvider.startRangeLon.toStringAsFixed(5)}',
                                        style: sfProStyle600SemiBold.copyWith(fontSize: 13),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                              width: 4,
                              height: 100,
                              decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(3))),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Helper.toScreen(const RangeSelectScreen(hasFromStartRange: false));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 5),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(.2),
                                          blurRadius: 10.0,
                                          spreadRadius: 3.0,
                                          offset: const Offset(0.0, 0.0))
                                    ],
                                    borderRadius: BorderRadius.circular(4)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('End Range', style: sfProStyle500Medium.copyWith(fontSize: 15)),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.edit, color: Colors.green, size: 17)
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(snapshot.data!.snapshot.child('Location').children.elementAt(5).value.toString(),
                                        style: sfProStyle600SemiBold.copyWith(fontSize: 12), textAlign: TextAlign.center),
                                    const SizedBox(height: 5),
                                    Text(
                                        '${locationProvider.endRangeLat.toStringAsFixed(5)}, ${locationProvider.endRangeLon.toStringAsFixed(5)}',
                                        style: sfProStyle600SemiBold.copyWith(fontSize: 13),
                                        textAlign: TextAlign.center)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 10),
                      Container(height: 4, decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(10))),
                      const SizedBox(height: 10),
                      Text('Child Detect Position:', style: sfProStyle700Bold.copyWith(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('${latLng.latitude}, ${latLng.longitude}', style: sfProStyle500Medium.copyWith(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(locationProvider.locationLists.isEmpty ? "Trying to find location..." : locationProvider.locationLists[0],
                          style: sfProStyle500Medium.copyWith(fontSize: 16)),
                      const SizedBox(height: 10),
                      Container(height: 4, decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(10))),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(.2),
                                        blurRadius: 10.0,
                                        spreadRadius: 3.0,
                                        offset: const Offset(0.0, 0.0))
                                  ],
                                  borderRadius: BorderRadius.circular(4)),
                              child: Column(
                                children: [
                                  Text('Start Range', style: sfProStyle500Medium.copyWith(fontSize: 16)),
                                  const SizedBox(height: 5),
                                  Text('Distance', style: sfProStyle500Medium.copyWith(fontSize: 16)),
                                  const SizedBox(height: 5),
                                  Text(
                                      locationProvider.distanceInMetersForStartRange > 999
                                          ? "${(locationProvider.distanceInMetersForStartRange / 1000.00).toStringAsFixed(2)} KM"
                                          : "${locationProvider.distanceInMetersForStartRange.toStringAsFixed(2)} M",
                                      style: sfProStyle700Bold.copyWith(fontSize: 17))
                                ],
                              ),
                            ),
                          ),
                          Container(
                              width: 4, height: 80, decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(3))),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(.2),
                                        blurRadius: 10.0,
                                        spreadRadius: 3.0,
                                        offset: const Offset(0.0, 0.0))
                                  ],
                                  borderRadius: BorderRadius.circular(4)),
                              child: Column(
                                children: [
                                  Text('End Range', style: sfProStyle500Medium.copyWith(fontSize: 16)),
                                  const SizedBox(height: 5),
                                  Text('Distance', style: sfProStyle500Medium.copyWith(fontSize: 16)),
                                  const SizedBox(height: 5),
                                  Text(
                                      locationProvider.distanceInMetersForEndRange > 999
                                          ? "${(locationProvider.distanceInMetersForEndRange / 1000.00).toStringAsFixed(2)} KM"
                                          : "${locationProvider.distanceInMetersForEndRange.toStringAsFixed(2)} M",
                                      style: sfProStyle700Bold.copyWith(fontSize: 17))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(height: 4, decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(10))),
                      const SizedBox(height: 10),
                      CustomButton(
                          btnTxt: 'Go To Full Map',
                          onTap: () {
                            Helper.toScreen(HomeScreen());
                          })
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
