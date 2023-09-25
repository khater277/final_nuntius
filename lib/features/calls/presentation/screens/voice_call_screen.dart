// ignore_for_file: use_build_context_synchronously

import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_sounds.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/calls/cubit/calls_cubit.dart';
import 'package:final_nuntius/features/calls/presentation/widgets/call_profile_image.dart';
import 'package:final_nuntius/features/calls/presentation/widgets/call_status_text.dart';
import 'package:final_nuntius/features/calls/presentation/widgets/call_timer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class VoiceCallScreen extends StatefulWidget {
  final String? userToken;
  final String rtcToken;
  final String channelName;
  final String image;
  final String name;
  final String phoneNumber;
  final bool receiveCall;
  const VoiceCallScreen({
    super.key,
    this.userToken,
    required this.rtcToken,
    required this.channelName,
    required this.image,
    required this.name,
    required this.phoneNumber,
    this.receiveCall = false,
  });

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  late CallsCubit callsCubit;
  final connectingPlayer = AudioPlayer();
  final callingPlayer = AudioPlayer();

  @override
  void initState() {
    callsCubit = CallsCubit.get(context);
    callsCubit.setupVoiceSDKEngine(
      userToken: widget.userToken,
      rtcToken: widget.rtcToken,
      channelName: widget.channelName,
    );

    Future.delayed(const Duration(seconds: 0)).then((value) async {
      await connectingPlayer.setAsset(AppSounds.connecting);
      await callingPlayer.setAsset(AppSounds.calling);
      if (!CallsCubit.get(context).isJoined) {
        connectingPlayer.setLoopMode(LoopMode.all);
        connectingPlayer.play();
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("AAAAAAAASSSSSSSSSSSSSDDDDDDDDDD");
      if (message.data['type'] == 'cancel-call' &&
          message.data['phoneNumber'] == widget.phoneNumber) {
        Go.back(context: context);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    callsCubit.leaveVoiceCall();
    connectingPlayer.dispose();
    callingPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CallsCubit, CallsState>(
      listener: (context, state) {
        if (CallsCubit.get(context).remoteUid == null &&
            widget.receiveCall == false) {
          connectingPlayer.stop();
          callingPlayer.setLoopMode(LoopMode.all);
          callingPlayer.play();
          Future.delayed(const Duration(seconds: 30)).then((value) {
            callingPlayer.stop();
            try {
              Go.back(context: context);
            } catch (error) {
              null;
            }
          });
        } else {
          connectingPlayer.stop();
          callingPlayer.stop();
        }
        state.maybeWhen(
          onUserOffline: () => Go.back(context: context),
          cancelCall: () => Go.back(context: context),
          cancelCallError: (errorMsg) => showSnackBar(
            context: context,
            message: errorMsg,
            color: AppColors.red,
          ),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = CallsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
              // title: LargeHeadText(text: "${cubit.uid} ${cubit.remoteUid}"),
              // centerTitle: true,
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
                  const CallStatusText(text: "connecting....")
                else if (cubit.remoteUid == null && widget.receiveCall == false)
                  const CallStatusText(text: "calling....")
                else if (cubit.remoteUid == null && widget.receiveCall == true)
                  const CallStatusText(text: "connecting....")
                else
                  const CallTimer()
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => state.maybeWhen(
              cancelCallLoading: () => () {},
              orElse: () {
                if (!cubit.isJoined) {
                  Go.back(context: context);
                } else {
                  cubit.cancelCall(userToken: widget.userToken!);
                }
                return null;
              },
            ),
            backgroundColor: AppColors.red,
            child: state.maybeWhen(
              cancelCallLoading: () => CustomCircleIndicator(
                color: AppColors.white,
                size: AppSize.s18,
                strokeWidth: 1,
              ),
              orElse: () => const Icon(
                IconBroken.Call,
                color: AppColors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
