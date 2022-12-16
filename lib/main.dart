import 'package:flutter/material.dart';
import 'package:flutter_clean_arch/app/app.dart';

import 'app/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModule();
  runApp(MyApp());
}
