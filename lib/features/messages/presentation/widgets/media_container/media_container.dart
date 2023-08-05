import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/messages/cubit/messages_cubit.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/media_container/view_file.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/media_container/view_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MediaContainer extends StatelessWidget {
  const MediaContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: AppHeight.h2, horizontal: AppWidth.w1),
              decoration: BoxDecoration(
                color: AppColors.lightBlack,
                borderRadius: BorderRadius.circular(AppSize.s20),
              ),
              height: MessagesCubit.get(context).messageType == MessageType.doc
                  ? AppHeight.h100
                  : AppHeight.h150,
              width: double.infinity,
              child: Center(
                  child: BlocBuilder<MessagesCubit, MessagesState>(
                builder: (context, state) => Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    if (MessagesCubit.get(context).messageType ==
                        MessageType.image)
                      Image.file(
                        MessagesCubit.get(context).file!,
                      )
                    else if (MessagesCubit.get(context).messageType ==
                        MessageType.video)
                      const ViewVideo()
                    else
                      const ViewFile(),
                    if (state == const MessagesState.sendMessageLoading() ||
                        state == const MessagesState.getFilePercentage())
                      CustomCircleIndicator(
                        percentage: MessagesCubit.get(context).filePercentage,
                      )
                  ],
                ),
              )),
            ),
            Padding(
              padding: EdgeInsets.only(top: AppHeight.h4, right: AppWidth.w4),
              child: InkWell(
                onTap: () => MessagesCubit.get(context).closeMediaContainer(),
                child: const Icon(
                  IconBroken.Close_Square,
                  color: AppColors.red,
                ),
              ),
            )
          ],
        ),
        SizedBox(height: AppHeight.h5),
      ],
    );
  }
}
