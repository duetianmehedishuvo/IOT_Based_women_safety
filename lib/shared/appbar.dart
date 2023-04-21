import 'package:flutter/material.dart';
import 'package:women_safety/util/theme/app_colors.dart';

class SafeHervenAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final bool isHome;

  SafeHervenAppBar(this.title, {Key? key, required this.isHome})
      : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: isHome == false ? false : true,
      backgroundColor: colorPrimary,
      title: isHome == false ? Text(title) : IconButton(onPressed: null, icon: Image.asset('assets/images/logos/white.png'), iconSize: 50),
    );
  }

  onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const SettingsScreen()),
        // );
        break;
      case 1:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const SignInScreen()),
        // );
        // (route) => false;
        break;
    }
  }
}
