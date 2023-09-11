import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/contacts/user_image.dart';
import 'package:final_nuntius/features/messages/cubit/messages_cubit.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_bubble/reply_story_message/message_text_and_time.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_bubble/reply_story_message/story_user_name_and_text.dart';
import 'package:flutter/material.dart';

class StoryReplyMessage extends StatelessWidget {
  final MessageModel messageModel;
  const StoryReplyMessage({super.key, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: AppColors.lightBlack.withOpacity(0.7),
              borderRadius: BorderRadius.circular(AppSize.s5)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: AppHeight.h6, horizontal: AppHeight.h8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StoryUserNameAndText(
                  name:
                      messageModel.senderId == HiveHelper.getCurrentUser()!.uId
                          ? "${MessagesCubit.get(context).user!.name}'s"
                          : "My",
                  text: messageModel.storyText ?? "empty",
                  messageType: messageModel.isImage == true
                      ? MessageType.image
                      : messageModel.isVideo == true
                          ? MessageType.video
                          : MessageType.text,
                ),
                SizedBox(width: AppWidth.w8),
                UserImage(image: MessagesCubit.get(context).user!.image ?? "")
              ],
            ),
          ),
        ),
        SizedBox(height: AppHeight.h2),
        MessageTextAndTime(message: messageModel.message!),
      ],
    );
  }
}
