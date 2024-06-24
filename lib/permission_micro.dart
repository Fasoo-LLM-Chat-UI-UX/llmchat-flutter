import 'dart:developer';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService extends GetxService {
  Future<PermissionStatus> requestMicrophonePermission() async {
    log("requestMicrophone: Requesting mic permission...");

    PermissionStatus status = await Permission.microphone.request();
    log("requestMicrophone: Permission status is $status.");

    return status;
  }

  Future<void> requestPermissions() async {
    // 예시: 여러 권한 요청
    await requestMicrophonePermission();
    // 필요한 다른 권한도 여기에 추가할 수 있습니다.
  }
}
