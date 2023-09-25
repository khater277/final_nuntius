import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/calls/presentation/screens/voice_call_screen.dart';
import 'package:flutter/material.dart';

class AcceptButton extends StatelessWidget {
  final CallType callType;
  final String rtcToken;
  final String channelName;
  final String image;
  final String name;
  final String phoneNumber;
  const AcceptButton({
    Key? key,
    required this.callType,
    required this.rtcToken,
    required this.channelName,
    required this.image,
    required this.name,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: "accept",
          onPressed: () => Go.off(
            context: context,
            screen: VoiceCallScreen(
              rtcToken: rtcToken,
              channelName: channelName,
              image: image,
              name: name,
              phoneNumber: phoneNumber,
              receiveCall: true,
            ),
          ),
          backgroundColor: Colors.green,
          child: Icon(
            callType == CallType.voice ? IconBroken.Call : IconBroken.Video,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: AppHeight.h1,
        ),
        const SecondaryText(text: "accept"),
      ],
    );
  }
}
