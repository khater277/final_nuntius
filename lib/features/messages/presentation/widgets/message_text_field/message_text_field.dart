import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/text_form_field.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/messages/cubit/messages_cubit.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/media_container/media_container.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_text_field/message_text_field_suffix_widget.dart';
import 'package:flutter/material.dart';

class SendMessageTextField extends StatelessWidget {
  final bool loadingCondition;
  const SendMessageTextField({super.key, required this.loadingCondition});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MessagesCubit.get(context).messageController!,
      builder: (BuildContext context, value, Widget? child) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppHeight.h2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (MessagesCubit.get(context).file != null)
                      const MediaContainer(),
                    CustomTextField(
                      hintText: 'enter your message',
                      controller: MessagesCubit.get(context).messageController!,
                      inputType: TextInputType.text,
                      suffixIcon: value.text.isEmpty
                          ? const MessageTextFieldSuffixWidget()
                          : null,
                      readOnly: MessagesCubit.get(context).file != null,
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppWidth.w5),
              InkWell(
                onTap: () {
                  if (value.text.isNotEmpty) {
                    MessagesCubit.get(context).sendMessage();
                  } else if (MessagesCubit.get(context).file != null) {
                    MessagesCubit.get(context).sendMediaMessage();
                  }
                },
                child: CircleAvatar(
                  radius: AppSize.s22,
                  backgroundColor: value.text.isNotEmpty ||
                          MessagesCubit.get(context).file != null
                      ? AppColors.blue
                      : Colors.grey,
                  child: loadingCondition
                      ? CustomCircleIndicator(
                          size: AppSize.s16,
                          color: AppColors.white,
                          strokeWidth: 1,
                        )
                      : Icon(
                          IconBroken.Send,
                          size: AppSize.s22,
                          color: value.text.isNotEmpty ||
                                  MessagesCubit.get(context).file != null
                              ? Colors.white
                              : AppColors.lightBlack,
                        ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
