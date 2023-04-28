import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:women_safety/util/helper.dart';

Widget zoomableCustomNetworkImage(Uint8List imageUrl, {double? height}) {
  return ExtendedImage.memory(
    imageUrl,
    height: height == 0 ? MediaQuery.of(Helper.navigatorKey.currentState!.context).size.height : height,
    mode: ExtendedImageMode.gesture,
    initGestureConfigHandler: (state) {
      return GestureConfig(
        minScale: 0.9,
        animationMinScale: 0.7,
        maxScale: 3.0,
        animationMaxScale: 3.5,
        speed: 1.0,
        inertialSpeed: 100.0,
        initialScale: 1.0,
        inPageView: false,
        initialAlignment: InitialAlignment.center,
      );
    },
    loadStateChanged: (ExtendedImageState state) {
      switch (state.extendedImageLoadState) {
        case LoadState.loading:
          CircularProgressIndicator();
          break;
        case LoadState.completed:
          ExtendedRawImage(image: state.extendedImageInfo?.image);
          break;
        case LoadState.failed:
          GestureDetector(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
            onTap: () {
              state.reLoadImage();
            },
          );
          break;
      }
      return null;
    },
  );
}
