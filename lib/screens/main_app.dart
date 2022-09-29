import 'package:cupertino_bmi/screens/home_screen.dart';
import 'package:cupertino_bmi/screens/user_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final List<Widget> screens = const [HomeScreen(), UserInfoScreen()];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Cupertino BMI'),
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person), label: 'User History'),
        ]),
        tabBuilder: (context, index) => CupertinoTabView(
          builder: (context) => screens[index],
        ),
      ),
    );
  }
}
