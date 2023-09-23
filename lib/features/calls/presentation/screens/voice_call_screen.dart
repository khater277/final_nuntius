import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/calls/cubit/calls_cubit.dart';
import 'package:final_nuntius/features/calls/presentation/widgets/call_profile_image.dart';
import 'package:final_nuntius/features/calls/presentation/widgets/call_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoiceCallScreen extends StatefulWidget {
  final String? userToken;
  final String rtcToken;
  final String channelName;
  final String image;
  final String name;
  final bool receiveCall;
  const VoiceCallScreen({
    super.key,
    this.userToken,
    required this.rtcToken,
    required this.channelName,
    required this.image,
    required this.name,
    this.receiveCall = false,
  });

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  late CallsCubit callsCubit;

  @override
  void initState() {
    callsCubit = CallsCubit.get(context);
    callsCubit.setupVoiceSDKEngine(
      userToken: widget.userToken,
      rtcToken: widget.rtcToken,
      channelName: widget.channelName,
    );
    super.initState();
  }

  @override
  void dispose() {
    callsCubit.leaveVoiceCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CallsCubit, CallsState>(
      listener: (context, state) {
        state.maybeWhen(
          onUserOffline: () => Go.back(context: context),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = CallsCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              title: LargeHeadText(text: "${cubit.uid} ${cubit.remoteUid}"),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CallProfileImage(image: widget.image),
                  SizedBox(height: AppHeight.h25),
                  LargeHeadText(
                    text: widget.name,
                    size: FontSize.s16,
                  ),
                  SizedBox(height: AppHeight.h4),
                  if (!cubit.isJoined)
                    SecondaryText(
                      text: "connecting....",
                      isButton: true,
                      size: FontSize.s13,
                    )
                  else if (cubit.remoteUid == null)
                    SecondaryText(
                      text: "calling....",
                      isButton: true,
                      size: FontSize.s13,
                    )
                  else
                    const CallTimer()
                  // if (!widget.receiveCall)
                  //   state.maybeWhen(
                  //     onUserJoined: () => const CallTimer(),
                  //     orElse: () => SecondaryText(
                  //       text: state.maybeWhen(
                  //           joinVoiceCallLoading: () => "connecting....",
                  //           orElse: () => "calling...."),
                  //       isButton: true,
                  //       size: FontSize.s13,
                  //     ),
                  //   )
                  // else
                  //   state.maybeWhen(
                  //     joinVoiceCall: () => const CallTimer(),
                  //     orElse: () => SecondaryText(
                  //       text: "connecting....",
                  //       isButton: true,
                  //       size: FontSize.s13,
                  //     ),
                  //   ),
                ],
              ),
            )
            // state.maybeWhen(
            //   joinVoiceCallLoading: () =>
            //       const Center(child: CustomCircleIndicator()),
            //   orElse: () => Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             CallProfileImage(image: widget.image),
            //             SizedBox(height: AppHeight.h10),
            //             // CallContentFriendName(name: widget.name),
            //             // SizedBox(height: AppHeight.h2),
            //             // if (widget.senderID == uId && _remoteUid == 0)
            //             //   const CallContentCalling()
            //             // else
            //             //   const CallContentTime()
            //           ],
            //         ),
            // ),
            );
      },
    );
  }

  Widget _status() {
    String statusText;

    if (!CallsCubit.get(context).isJoined) {
      statusText = 'Join a channel';
    } else if (CallsCubit.get(context).remoteUid == null) {
      statusText = 'Waiting for a remote user to join...';
    } else {
      statusText =
          'Connected to remote user, uid:${CallsCubit.get(context).remoteUid}';
    }

    return Text(
      statusText,
    );
  }
}
