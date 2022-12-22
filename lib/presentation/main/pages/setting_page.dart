import 'package:flutter/material.dart';

import '../../resources/strings_manager.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _HomePageState();
}

class _HomePageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(AppStrings.settings),
    );
  }
}
