import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:women_safety/util/theme/app_colors.dart';
import 'package:women_safety/widgets/custom_button.dart';
import 'package:women_safety/widgets/network_image_widget.dart';
import 'package:women_safety/widgets/snackbar_message.dart';

class PhotoDetailsScreen extends StatelessWidget {
  final Uint8List imageURL;

  const PhotoDetailsScreen({required this.imageURL, Key? key}) : super(key: key);

  void saveImage(path) async {
    bool? status = await GallerySaver.saveImage(path, albumName: "child_safety");
    if (status!) {
      showMessage(message: 'Save Successfully',isError: false);
    } else {
      showMessage(message: 'Failed to save Image',isError: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: zoomableCustomNetworkImage( imageURL, height: 0)),
            Positioned(
              right: 10,
              top: 10,
              child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => CustomButton(
                            btnTxt: 'Download',
                            textWhiteColor: true,
                            fontSize: 16,
                            radius: 2,
                            onTap: () {
                              saveImage(imageURL);
                              Navigator.pop(context);
                            }));
                  },
                  child:  const CircleAvatar(backgroundColor: colorPrimary, child: Icon(Icons.save, color: Colors.white))),
            )
          ],
        ),
      ),
    );
  }
}