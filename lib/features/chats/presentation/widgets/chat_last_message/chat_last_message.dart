import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/chats/presentation/widgets/chat_last_message/deleted_last_message.dart';
import 'package:final_nuntius/features/chats/presentation/widgets/chat_last_message/media_last_message.dart';
import 'package:final_nuntius/features/chats/presentation/widgets/chat_last_message/text_last_message.dart';
import 'package:flutter/material.dart';

enum MessageType { deleted, text, image, video, doc }

class ChatLastMessage extends StatelessWidget {
  final MessageType messageType;
  const ChatLastMessage({Key? key, required this.messageType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // if(lastMessage.senderID==uId)
        SecondaryText(
          text: 'you : ',
          size: FontSize.s13,
        ),
        Expanded(
          child: messageType == MessageType.deleted
              ? const DeletedLastMessage()
              : messageType == MessageType.video
                  ? const MediaLastMessage(
                      icon: IconBroken.Video, name: 'video')
                  : messageType == MessageType.image
                      ? const MediaLastMessage(
                          icon: IconBroken.Image, name: 'image')
                      : messageType == MessageType.doc
                          ? const MediaLastMessage(
                              icon: IconBroken.Document, name: 'document')
                          : const TextLastMessage(message: "see you soon!"),
        ),
        // if (lastMessage.isRead == false)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppWidth.w2),
          child: CircleAvatar(
            radius: AppSize.s4,
            backgroundColor: AppColors.blue,
          ),
        )
      ],
    );
  }
}
