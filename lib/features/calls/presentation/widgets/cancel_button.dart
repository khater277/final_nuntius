import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_images.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/calls/cubit/calls_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CancelButton extends StatelessWidget {
  final CallType callType;
  final String userToken;
  const CancelButton(
      {Key? key, required this.callType, required this.userToken})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<CallsCubit, CallsState>(
          builder: (context, state) => FloatingActionButton(
            heroTag: "cancel",
            onPressed: () => state.maybeWhen(
              cancelCallLoading: () => () {},
              orElse: () =>
                  CallsCubit.get(context).cancelCall(userToken: userToken),
            ),
            backgroundColor: Colors.red,
            child: state.maybeWhen(
              cancelCallLoading: () => CustomCircleIndicator(
                color: AppColors.white,
                size: AppSize.s16,
                strokeWidth: 1,
              ),
              orElse: () => callType == CallType.voice
                  ? const Icon(
                      IconBroken.Call_Missed,
                      color: Colors.white,
                    )
                  : const ImageIcon(
                      AssetImage(AppImages.missedVideoCall),
                      color: Colors.white,
                    ),
            ),
          ),
        ),
        SizedBox(height: AppHeight.h1),
        const SecondaryText(text: "cancel"),
      ],
    );
  }
}
