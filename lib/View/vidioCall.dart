import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'dart:math' as math;

class VideoCall extends StatelessWidget {
  final String uid;
  VideoCall({super.key, required this.uid});

  final String userId = math.Random().nextInt(1000).toString();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: 1088176388,
        appSign: '1b85ae6f7fe70b3d878ee21b8e055d53738a77746a177ab33d5a464f5185b9b3',
        userID: userId,
        callID: uid,
        config:  ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()..video, 
        userName: 'username$userId',
      ),
    );
  }
}
