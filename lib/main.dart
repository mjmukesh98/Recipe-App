import 'package:demo/core/services/app_prefernces.dart';
import 'package:demo/core/services/hive_service.dart';
import 'package:demo/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreference.init(); // OR via GetIt
  await Hive.initFlutter();
  await HiveService.init();
  init();
  runApp(const MyApp());
}
