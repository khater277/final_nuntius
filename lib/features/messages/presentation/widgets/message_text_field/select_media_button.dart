import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/messages/cubit/messages_cubit.dart';
import 'package:flutter/material.dart';

class SelectMediaButton extends StatelessWidget {
  final MessageType messageType;
  const SelectMediaButton({
    super.key,
    required this.messageType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppWidth.w2),
      child: GestureDetector(
        onTap: () {
          if (messageType == MessageType.image) {
            MessagesCubit.get(context).pickMessageImage();
          } else if (messageType == MessageType.video) {
            MessagesCubit.get(context).pickMessageVideo();
          } else {
            MessagesCubit.get(context).pickMessageFile();
          }
        },
        child: Icon(
          messageType == MessageType.image
              ? IconBroken.Image
              : messageType == MessageType.video
                  ? IconBroken.Video
                  : IconBroken.Folder,
          size: AppSize.s20,
          color: AppColors.blue.withOpacity(0.8),
        ),
      ),
    );
  }
}
