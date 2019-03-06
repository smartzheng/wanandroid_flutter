import 'package:flutter/material.dart';
import 'package:wananzhuo_flutter/pages/discover/DiscoverPage.dart';
import 'package:wananzhuo_flutter/pages/home/HomePage.dart';
import 'package:wananzhuo_flutter/pages/me/MePage.dart';

void main() => runApp(WanAndroidApp());
const navigationItems = ['首页', '发现', '我的'];

class WanAndroidApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WanAndroidApp();
  }
}

class _WanAndroidApp extends State<WanAndroidApp> {
  var currentIndex = 0;
  var indexedStack;
  List<BottomNavigationBarItem> navigationViews;

  @override
  Widget build(BuildContext context) {
    indexedStack = IndexedStack(
        children: <Widget>[HomePage(), DiscoverPage(), MePage()],
        index: currentIndex);
    
    return MaterialApp(
      title: '玩安卓',
      theme: ThemeData(
        primaryColor: Color(0xFF00D8A0),
      ),
      home: new Scaffold(
        appBar: AppBar(
          title: Text('玩安卓'),
        ),
        body: indexedStack,
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Color(0xFF00D8A0),
          items: navigationViews
              .map((BottomNavigationBarItem navigationView) => navigationView)
              .toList(),
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    navigationViews = [
      BottomNavigationBarItem(
          icon:
              Image.asset('lib/images/home_default.png', width: 30, height: 30),
          activeIcon:
              Image.asset('lib/images/home_active.png', width: 30, height: 30),
          title: Text(navigationItems[0])),
      BottomNavigationBarItem(
          icon: Image.asset('lib/images/discover_default.png',
              width: 30, height: 30),
          activeIcon: Image.asset('lib/images/discover_active.png',
              width: 30, height: 30),
          title: Text(navigationItems[1])),
      BottomNavigationBarItem(
          icon: Image.asset('lib/images/me_default.png', width: 30, height: 30),
          activeIcon:
              Image.asset('lib/images/me_active.png', width: 30, height: 30),
          title: Text(navigationItems[2]))
    ];
  }
}
