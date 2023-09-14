import 'package:final_nuntius/core/shared_widgets/button.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/features/calls/cubit/calls_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoiceCallScreen extends StatefulWidget {
  final String token;
  final String channelName;
  const VoiceCallScreen(
      {super.key, required this.token, required this.channelName});

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  late CallsCubit callsCubit;

  @override
  void initState() {
    callsCubit = CallsCubit.get(context);
    callsCubit.setupVoiceSDKEngine(
      token: widget.token,
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
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = CallsCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: state.maybeWhen(
            joinVoiceCallLoading: () =>
                const Center(child: CustomCircleIndicator()),
            orElse: () => ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              children: [
                // Status text
                SizedBox(height: 40, child: Center(child: _status())),
                // Button Row
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomButton(
                        text: "Join",
                        onPressed: () => {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        text: "Leave",
                        onPressed: () => {cubit.leaveVoiceCall()},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
