import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/messages/cubit/messages_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CallButton extends StatelessWidget {
  final CallType callType;

  const CallButton({Key? key, required this.callType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () =>
              MessagesCubit.get(context).generateToken(callType: callType),
          icon: state.maybeWhen(
            generateTokenLoading: (callType) {
              if (callType == this.callType) {
                return CustomCircleIndicator(size: AppSize.s17);
              } else {
                return Icon(
                  this.callType == CallType.video
                      ? IconBroken.Video
                      : IconBroken.Call,
                  color: AppColors.blue,
                  size: AppSize.s20,
                );
              }
            },
            orElse: () => Icon(
              callType == CallType.video ? IconBroken.Video : IconBroken.Call,
              color: AppColors.blue,
              size: AppSize.s20,
            ),
          ),
        );
      },
    );
  }
}
