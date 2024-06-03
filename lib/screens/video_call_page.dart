import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallPage extends StatefulWidget {
  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  appId: "da758e4a2f0c41d9998926401ff127d5", 
    channelName: "test", 
    tempToken: token, 
  static const String appId = 'YOUR_AGORA_APP_ID';
  static const String channelName = 'test';
  static const String token = 'YOUR_TEMP_TOKEN';

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await [Permission.camera, Permission.microphone].request();

    await AgoraRtcEngine.create(appId);
    await AgoraRtcEngine.enableVideo();

    AgoraRtcEngine.joinChannel(token, channelName, null, 0);

    AgoraRtcEngine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        print('joinChannelSuccess $channel $uid $elapsed');
      },
      userJoined: (uid, elapsed) {
        print('userJoined $uid $elapsed');
      },
      userOffline: (uid, reason) {
        print('userOffline $uid $reason');
      },
    ));
  }

  @override
  void dispose() {
    super.dispose();
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call'),
      ),
      body: Stack(
        children: <Widget>[
          AgoraRenderWidget(0, local: true, preview: true),
          Positioned(
            top: 20,
            left: 20,
            child: AgoraRenderWidget(1),
          ),
        ],
      ),
    );
  }
}
