import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aerochat_webview/permission_micro.dart';
import 'package:aerochat_webview/offline.dart';
import 'package:aerochat_webview/webview.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _permissionService = Get.find<PermissionService>();

  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future _initializeApp() async {
    var connectivity = await Connectivity().checkConnectivity();
    Get.log('connectivity: $connectivity');

    if (connectivity == ConnectivityResult.none) {
      setState(() {
        _isOffline = true;
      });
    } else {
      setState(() {
        _isOffline = false;
      });
      // 권한 요청
      await _permissionService.requestPermissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isOffline) {
      return OfflineScreen(onRefresh: () => _initializeApp());
    } else {
      return const WebViewScreen();
    }
  }
}
