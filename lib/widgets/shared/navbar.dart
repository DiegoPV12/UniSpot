import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:unispot/views/profile/profile_page.dart';
import 'package:unispot/views/spaces/spaces_page.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final BuildContext navigationContext;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.navigationContext,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      indicatorColor: const Color.fromARGB(255, 233, 201, 213),
      surfaceTintColor: const Color.fromARGB(255, 233, 201, 213),
      selectedIndex: currentIndex,
      onDestinationSelected: (int index) {
        if (index == 1) {
          Navigator.pushReplacement(
            navigationContext,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        } else if (index == 0) {
          Navigator.pushReplacement(
            navigationContext,
            MaterialPageRoute(builder: (context) => const SpacesListPage()),
          );
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(
            CupertinoIcons.square_grid_2x2
          ),
          selectedIcon: Icon(
            CupertinoIcons.square_grid_2x2_fill,
            color: Color.fromARGB(255, 129, 40, 75)
          ),
          label: 'Espacios',
        ),
        NavigationDestination(
          icon: Icon(CupertinoIcons.person),
          selectedIcon: Icon(
            CupertinoIcons.person_fill,
            color: Color.fromARGB(255, 129, 40, 75)
          ),
          label: 'Usuario',
        ),
      ],
    );
  }
}
