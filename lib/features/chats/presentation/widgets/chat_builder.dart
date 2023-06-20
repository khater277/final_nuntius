import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/chats/presentation/widgets/chat_last_message/chat_last_message.dart';
import 'package:final_nuntius/features/chats/presentation/widgets/chat_name_and_date.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/contacts/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatBuilder extends StatelessWidget {
  final int index;
  const ChatBuilder({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(index),
      startActionPane:
          swipeToDelete(context: context, rightPadding: AppWidth.w10),
      endActionPane: swipeToDelete(context: context, leftPadding: AppWidth.w10),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppHeight.h18),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Get.to(() =>
                //     MessagesScreen(
                //       user: chats[index],
                //       isFirstMessage:
                //           false,
                //     ));
              },
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  children: [
                    const UserImage(
                      image: '',
                      isChat: true,
                    ),
                    SizedBox(width: AppWidth.w5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ChatNameAndDate(
                            name: 'Ahmed Khater',
                            date: '11/5/2023',
                          ),
                          SizedBox(height: AppHeight.h4),
                          const ChatLastMessage(
                            messageType: MessageType.doc,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ActionPane swipeToDelete({
    required BuildContext context,
    // required String chatID,
    double? rightPadding,
    double? leftPadding,
  }) {
    return ActionPane(
      dismissible: DismissiblePane(onDismissed: () {
        print("ASD");
      }),
      dragDismissible: false,
      motion: Padding(
        padding: EdgeInsets.only(
          right: rightPadding ?? 0,
          left: leftPadding ?? 0,
        ),
        child: const ScrollMotion(),
      ),
      children: [
        SlidableAction(
          onPressed: (value) {
            // AppCubit.get(context).deleteChat(chatID: chatID);
          },
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: IconBroken.Delete,
          label: 'Delete',
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
      ],
    );
  }
}
