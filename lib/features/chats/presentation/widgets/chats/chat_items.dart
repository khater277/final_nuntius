import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/chats/presentation/widgets/chats/chat_builder.dart';

import 'package:final_nuntius/features/messages/data/models/last_message/last_message_model.dart';
import 'package:flutter/material.dart';

class ChatsItems extends StatelessWidget {
  final List<UserData> users;
  final List<LastMessageModel> lastMessages;
  const ChatsItems({
    super.key,
    required this.users,
    required this.lastMessages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ChatBuilder(
                  user: users[index],
                  lastMessage: lastMessages[index],
                );
              },
              separatorBuilder: (context, index) => Divider(
                    color: AppColors.grey.withOpacity(0.08),
                  ),
              itemCount: users.length),
        )
      ],
    );
  }
}
