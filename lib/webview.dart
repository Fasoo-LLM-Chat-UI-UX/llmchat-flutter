import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:aerochat_webview/permission_micro.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final PlatformWebViewController _controller;

  final _permissionService = Get.find<PermissionService>();

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      _controller =
          WebKitWebViewController(WebKitWebViewControllerCreationParams())
            ..setAllowsBackForwardNavigationGestures(true);
    } else {
      _controller =
          AndroidWebViewController(AndroidWebViewControllerCreationParams());
    }

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
          LoadRequestParams(uri: Uri.parse('https://www.aero-chat.com/')))
      ..setOnPlatformPermissionRequest((request) => request.grant())
      ..enableZoom(false)
      ..addJavaScriptChannel(
        JavaScriptChannelParams(
          name: 'FlutterBridge',
          onMessageReceived: (message) async {
            log("onMessageReceived: Message is ${message.message}.");
            switch (message.message) {
              case 'requestMicrophonePermission':
                if (await _permissionService.requestMicrophonePermission() ==
                    PermissionStatus.granted) {
                  _controller.runJavaScript(
                      "MicrophonePermissionBridge.receiveMessage('GRANTED')");
                } else {
                  _controller.runJavaScript(
                      "MicrophonePermissionBridge.receiveMessage('DENIED')");
                }
                break;
              default:
                break;
            }
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PlatformWebViewWidget(
                  PlatformWebViewWidgetCreationParams(
                    controller: _controller,
                  ),
                ).build(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 뒤로 가기 버튼 처리
  Future<bool> _exitApp(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    } else {
      return true;
    }
  }
}
