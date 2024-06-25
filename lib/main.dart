//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:aerochat_webview/permission_micro.dart';
import 'package:aerochat_webview/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();

  runApp(const MyApp());
}

Future<void> initServices() async {
  Get.put(PermissionService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AreoChat',
        themeMode: ThemeMode.dark,
        theme: ThemeData(useMaterial3: true),
        home: const App(),
      ),
    );
  }
}
