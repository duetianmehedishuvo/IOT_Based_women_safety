import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:women_safety/helper/message_dao.dart';
import 'package:women_safety/provider/location_provider.dart';
import 'package:women_safety/provider/weather_provider.dart';
import 'package:women_safety/screen/photos/photos_details_screen.dart';
import 'package:women_safety/util/helper.dart';
import 'package:women_safety/util/theme/app_colors.dart';
import 'package:women_safety/util/theme/text.styles.dart';
import 'package:women_safety/widgets/raw_image_widget.dart';

class PhotosScreen extends StatelessWidget {
  const PhotosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photos'), backgroundColor: colorPrimary),
      body: Consumer2<LocationProvider, WeatherProvider>(
        builder: (context, locationProvider, weatherProvider, child) => StreamBuilder(
            stream: MessageDao.messagesRef.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (!snapshot.hasData || locationProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                  itemCount: snapshot.data!.snapshot.child('esp32-cam').children.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  itemBuilder: (context, index) {
                    String image = snapshot.data!.snapshot.child('esp32-cam').children.elementAt(index).child('photo').value.toString();
                    return InkWell(
                      onTap: () {
                        Helper.toScreen(PhotoDetailsScreen(
                          imageURL: const Base64Decoder().convert(image.split(',').last.replaceAll('%2F', '/').replaceAll('%2B', '+')),
                        ));
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                              border: Border.all(color: colorPrimary, width: 5),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(index == 0 ? 10 : 0),
                                topRight: Radius.circular(index == 0 ? 10 : 0),
                                bottomRight:
                                    Radius.circular(index == snapshot.data!.snapshot.child('esp32-cam').children.length - 1 ? 10 : 0),
                                bottomLeft:
                                    Radius.circular(index == snapshot.data!.snapshot.child('esp32-cam').children.length - 1 ? 10 : 0),
                              )),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              getImageBase64(image),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: const BoxDecoration(color: colorPrimary),
                                child: Text(
                                  'Image: ${index + 1}',
                                  style: sfProStyle500Medium.copyWith(fontSize: 15, color: Colors.white),
                                ),
                              )
                            ],
                          )),
                    );
                    // return SizedBox();
                  });
            }),
      ),
    );
  }
}
