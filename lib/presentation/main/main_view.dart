import 'package:flutter/material.dart';
import 'package:flutter_clean_arch/presentation/main/pages/home_page.dart';
import 'package:flutter_clean_arch/presentation/main/pages/notification_page.dart';
import 'package:flutter_clean_arch/presentation/main/pages/search_page.dart';
import 'package:flutter_clean_arch/presentation/main/pages/setting_page.dart';
import 'package:flutter_clean_arch/presentation/resources/color_manager.dart';
import 'package:flutter_clean_arch/presentation/resources/strings_manager.dart';
import 'package:flutter_clean_arch/presentation/resources/values_manager.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Widget> pages = [
    HomePage(),
    SearchPage(),
    NotificationPage(),
    SettingPage()
  ];
  List<String> titles = [
    AppStrings.home,
    AppStrings.search,
    AppStrings.notifications,
    AppStrings.settings
  ];

  var _title = AppStrings.home;
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: ColorManager.lightGrey,
              spreadRadius: AppSize.s1,
            )
          ],
        ),
        child: BottomNavigationBar(
          selectedItemColor: ColorManager.primary,
          unselectedItemColor: ColorManager.grey,
          currentIndex: _currentIndex,
          onTap: onTap,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_max_outlined), label: AppStrings.home),
            BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined), label: AppStrings.search),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none_outlined),
                label: AppStrings.notifications),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: AppStrings.settings),
          ],
        ),
      ),
    );
  }

  onTap(int index) {
    setState(() {
      _currentIndex = index;
      _title = _title[index];
    });
  }
}
