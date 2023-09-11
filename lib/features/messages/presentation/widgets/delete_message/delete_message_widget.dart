import 'package:final_nuntius/core/shared_widgets/alert_dialog.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/messages/cubit/messages_cubit.dart';
import 'package:flutter/material.dart';

class DeleteMessageWidget extends StatelessWidget {
  final String messageId;
  const DeleteMessageWidget({
    super.key,
    required this.messageId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showAlertDialog(
        context: context,
        text: "Are you sure you want to delete this message?",
        okPressed: () =>
            MessagesCubit.get(context).deleteMessage(messageId: messageId),
      ),
      child: Row(
        children: [
          const PrimaryText(
            text: "delete message",
            color: AppColors.grey,
          ),
          const Spacer(),
          Icon(
            IconBroken.Delete,
            color: AppColors.red,
            size: AppSize.s18,
          ),
          SizedBox(width: AppWidth.w5),
        ],
      ),
    );
  }
}
