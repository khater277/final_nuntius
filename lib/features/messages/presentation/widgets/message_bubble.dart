import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isLastMessage;
  const MessageBubble({
    super.key,
    required this.message,
    required this.isLastMessage,
  });

  @override
  Widget build(BuildContext context) {
    bool isMyMessage = message.senderId == HiveHelper.getCurrentUser()!.uId;
    return Padding(
      padding: EdgeInsets.only(bottom: isLastMessage ? AppHeight.h60 : 0),
      child: Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: AppHeight.h8,
                horizontal: AppWidth.w12,
              ),
              decoration: BoxDecoration(
                color: isMyMessage ? AppColors.blue : AppColors.lightBlack,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(!isMyMessage ? AppSize.s20 : 0),
                  topRight: Radius.circular(isMyMessage ? AppSize.s20 : 0),
                  bottomLeft: Radius.circular(AppSize.s20),
                  bottomRight: Radius.circular(AppSize.s20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: SmallHeadText(
                      text: "${message.message}",
                      size: FontSize.s13,
                      maxLines: 1000000,
                    ),
                  ),
                  SizedBox(width: AppWidth.w5),
                  SecondaryText(
                    text: DateFormat.jm().format(DateTime.parse(message.date!)),
                    color: AppColors.grey,
                    size: FontSize.s10,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
