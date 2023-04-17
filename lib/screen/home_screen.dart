import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:women_safety/bloc/application_bloc.dart';
import 'package:women_safety/database/message_dao.dart';
import 'package:women_safety/shared/bottom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraPosition initialCameraPosition =
      const CameraPosition(target: LatLng(37.42796133580664, -122.085749655962), zoom: 12, tilt: 80, bearing: 30);
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  BitmapDescriptor? markerbitmap;
  BitmapDescriptor? markerbitmap2;
  int initialize = 0;
  AudioPlayer? player;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ApplicationBloc>(context, listen: false).resetManu();
    bitmap();
  }

  void bitmap() async {
    markerbitmap = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), "assets/images/robo1.png");
    markerbitmap2 = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), "assets/images/marker.png");
    player = AudioPlayer();
    await player!.setLoopMode(LoopMode.all);
    markers.add(Marker(
        markerId: const MarkerId('markeridsssjjsjs'),
        position: const LatLng(37.42796133580664, -122.085749655962), //position of marker
        infoWindow: const InfoWindow(title: 'Starting Point ', snippet: 'Start Marker'),
        icon: markerbitmap! //Icon for Marker
        ));
    markers.add(Marker(
        markerId: const MarkerId('121212'),
        position: const LatLng(23.949060173720277, 90.3905911397721), //position of marker
        infoWindow: const InfoWindow(title: 'Gacha Police Station', snippet: 'Start Marker'),
        icon: markerbitmap2! //Icon for Marker
        ));
    markers.add(Marker(
        markerId: const MarkerId('2dwewewew'),
        position: const LatLng(23.980475357194262, 90.3802651387415), //position of marker
        infoWindow: const InfoWindow(title: 'Vogra Police Camp', snippet: 'Start Marker'),
        icon: markerbitmap2! //Icon for Marker
        ));
    markers.add(Marker(
        markerId: const MarkerId('wwewewdcfee2323'),
        position: const LatLng(23.975891124285642, 90.38775262997532), //position of marker
        infoWindow: const InfoWindow(title: 'Industrial Police-2, Gazipur.', snippet: 'Start Marker'),
        icon: markerbitmap2! //Icon for Marker
        ));
    markers.add(Marker(
        markerId: const MarkerId('ewewew232323232'),
        position: const LatLng(23.976518522091773, 90.39410410074655), //position of marker
        infoWindow: const InfoWindow(title: 'Industrial Police Gazipur, 2', snippet: 'Start Marker'),
        icon: markerbitmap2! //Icon for Marker
        ));
    markers.add(Marker(
        markerId: const MarkerId('qweyyeee'),
        position: const LatLng(23.994564854773795, 90.39486500457419), //position of marker
        infoWindow: const InfoWindow(title: 'Gazipur Metropoliton Police Headquarters', snippet: 'Start Marker'),
        icon: markerbitmap2! //Icon for Marker
        ));
    markers.add(Marker(
        markerId: const MarkerId('333656877522335465'),
        position: const LatLng(23.996267756880496, 90.40024987041753), //position of marker
        infoWindow: const InfoWindow(title: 'গাজীপুর পুলিশ লাইন্স', snippet: 'Start Marker'),
        icon: markerbitmap2! //Icon for Marker
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const MenuBottom(),
        body: StreamBuilder(
          stream: MessageDao.messagesRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.snapshot.child('Danger').value.toString() == '1') {
              if (!player!.playing) {
                player!.setAsset('assets/raw/alarm.mp3');
                player!.play();
              }
            } else {
              player!.stop();
            }

            LatLng latLng = LatLng(double.parse(snapshot.data!.snapshot.child('Location').children.elementAt(1).value.toString()),
                double.parse(snapshot.data!.snapshot.child('Location').children.elementAt(0).value.toString()));

            if (initialize != 0) {
              mapController!.moveCamera(CameraUpdate.newLatLng(latLng));
              markers.add(Marker(
                  markerId: const MarkerId('markeridsssjjsjs'),
                  position: latLng, //position of marker
                  infoWindow: const InfoWindow(title: 'My Location ', snippet: 'My Detiails'),
                  icon: markerbitmap! //Icon for Marker
                  ));
            }
            initialize = 1;
            return GoogleMap(
              mapType: MapType.hybrid,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              markers: markers,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController? controller) {
                mapController = controller;
                mapController!.moveCamera(CameraUpdate.newLatLng(latLng));
                markers.add(Marker(
                    markerId: const MarkerId('markeridsssjjsjs'),
                    position: latLng, //position of marker
                    infoWindow: const InfoWindow(title: 'My Location ', snippet: 'My Detiails'),
                    icon: markerbitmap! //Icon for Marker
                    ));
                setState(() {});
              },
            );
          },
        ),
      ),
    );
  }
}
