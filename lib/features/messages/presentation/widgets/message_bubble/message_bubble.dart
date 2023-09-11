import 'package:final_nuntius/core/hive/hive_helper.dart';

import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/messages/cubit/messages_cubit.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_bubble/deleted_message.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_bubble/doc_message.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_bubble/image_message.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_bubble/reply_story_message/story_reply_message.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_bubble/text_message.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_bubble/video_message.dart';
import 'package:flutter/material.dart';

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
    return GestureDetector(
      onLongPress: () =>
          MessagesCubit.get(context).showDeleteMessageBottomSheet(
        context: context,
        messageId: message.messageId!,
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: isLastMessage ? AppHeight.h10 : 0),
        child: Row(
          mainAxisAlignment:
              isMyMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                // width: message.isStoryReply == true
                //     ? MediaQuery.sizeOf(context).width * 0.75
                //     : null,
                constraints: BoxConstraints(
                    maxWidth: message.isStoryReply == true
                        ? MediaQuery.sizeOf(context).width * 0.75
                        : double.infinity,
                    minWidth: message.isStoryReply == true
                        ? MediaQuery.sizeOf(context).width * 0.5
                        : 0.0),
                padding: EdgeInsets.symmetric(
                  vertical: message.message != "" ? AppHeight.h8 : 0,
                  horizontal: message.message != "" ? AppWidth.w12 : 0,
                ).subtract(EdgeInsets.only(
                  top: message.isStoryReply == true ? AppHeight.h6 : 0,
                  right: message.isStoryReply == true ? AppWidth.w8 : 0,
                  left: message.isStoryReply == true ? AppWidth.w8 : 0,
                )),
                decoration: BoxDecoration(
                  color: message.isVideo == true
                      ? AppColors.blue.withOpacity(0.2)
                      : isMyMessage
                          ? AppColors.blue
                          : AppColors.lightBlack,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(!isMyMessage ? AppSize.s20 : 0),
                    topRight: Radius.circular(isMyMessage ? AppSize.s20 : 0),
                    bottomLeft: Radius.circular(AppSize.s20),
                    bottomRight: Radius.circular(AppSize.s20),
                  ),
                ),
                child: message.isDeleted == true
                    ? DeletedMessage(date: message.date!)
                    : message.isStoryReply == true
                        ? StoryReplyMessage(messageModel: message)
                        : message.isImage == true
                            ? ImageMessage(
                                isMyMessage: isMyMessage, message: message)
                            : message.isVideo == true
                                ? VideoMessage(videoUrl: message.media!)
                                : message.isDoc == true
                                    ? DocMessage(message: message)
                                    : TextMessage(message: message),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
