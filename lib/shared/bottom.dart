import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:women_safety/helper/application_bloc.dart';
import 'package:women_safety/screen/helpline_number_screen.dart';
import 'package:women_safety/screen/home_screen.dart';
import 'package:women_safety/screen/places.dart';

class MenuBottom extends StatefulWidget {
  const MenuBottom({Key? key}) : super(key: key);

  @override
  State<MenuBottom> createState() => _MenuBottomState();
}

class _MenuBottomState extends State<MenuBottom> {
  void _onItemTapped(int index) {
    Provider.of<ApplicationBloc>(context, listen: false).changeMenuIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationBloc>(
        builder: (context, applicationBlock, child) => BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: (int index) {
                switch (index) {
                  case 0:
                    _onItemTapped(0);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                    break;
                  case 1:
                    _onItemTapped(1);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const PlacesScreen()),
                    );
                    break;
                  case 2:
                    _onItemTapped(2);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HelplineNumberScreen()),
                    );
                    break;
                  case 3:
                    _onItemTapped(3);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const ChatScreen()),
                    // );
                    break;
                }
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: applicationBlock.selectMenuIndex == 0 ? Colors.purple : Colors.grey,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.location_on,
                    color: applicationBlock.selectMenuIndex == 1 ? Colors.purple : Colors.grey,
                  ),
                  label: 'Places',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.health_and_safety,
                    color: applicationBlock.selectMenuIndex == 2 ? Colors.purple : Colors.grey,
                  ),
                  label: 'Get Help',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.devices_other,
                    color: applicationBlock.selectMenuIndex == 3 ? Colors.purple : Colors.grey,
                  ),
                  label: 'Other',
                ),
              ],
              currentIndex: applicationBlock.selectMenuIndex,
              selectedItemColor: Colors.purple[500],
            ));
  }
}
