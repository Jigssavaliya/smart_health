import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';

import 'app/data/service/SupabaseService.dart';
import 'app/routes/app_pages.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnv();
  await SupabaseService.instance.databaseConnection();
  runApp(
    GetMaterialApp(
      darkTheme: ThemeData.light(),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      title: "SmartHealth+",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

Future<void> loadEnv() async {
  await dotenv.load(fileName: ".env");
}
