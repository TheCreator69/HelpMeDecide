import 'package:flutter/material.dart';
import 'package:helpmedecide/view/home_page.dart';
import 'package:helpmedecide/view/theme_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  NavigationPageState createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
  int _pageIndex = 0;

  Widget getPageByPageIndex(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return const ThemePage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPageByPageIndex(_pageIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.brush), label: "Themes")
        ],
        onTap: (int index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
}
