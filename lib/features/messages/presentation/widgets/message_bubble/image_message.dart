import 'package:final_nuntius/core/shared_widgets/network_image.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    super.key,
    required this.isMyMessage,
    required this.message,
  });

  final bool isMyMessage;
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppWidth.w250,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(!isMyMessage ? AppSize.s20 : 0),
          topRight: Radius.circular(isMyMessage ? AppSize.s20 : 0),
          bottomLeft: Radius.circular(AppSize.s20),
          bottomRight: Radius.circular(AppSize.s20),
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            CustomNetworkImage(imageUrl: message.media!, fit: BoxFit.contain),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: AppHeight.h3, horizontal: AppWidth.w5),
              child: SecondaryText(
                text: DateFormat.jm().format(DateTime.parse(message.date!)),
                color: AppColors.grey,
                size: FontSize.s10,
              ),
            )
          ],
        ),
      ),
    );
  }
}
