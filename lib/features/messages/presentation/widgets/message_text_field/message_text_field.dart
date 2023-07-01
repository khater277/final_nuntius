import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/text_form_field.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/messages/cubit/messages_cubit.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_text_field/message_text_field_suffix_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            children: [
              Expanded(
                child: CustomTextField(
                  hintText: 'enter your message',
                  controller: MessagesCubit.get(context).messageController!,
                  inputType: TextInputType.text,
                  suffixIcon: value.text.isEmpty
                      ? const MessageTextFieldSuffixWidget()
                      : null,
                ),
              ),
              SizedBox(width: AppWidth.w5),
              InkWell(
                onTap: () {
                  MessagesCubit.get(context).sendMessage(
                      phoneNumber: MessagesCubit.get(context).user!.phone!);
                },
                child: BlocBuilder<MessagesCubit, MessagesState>(
                  builder: (context, state) {
                    return CircleAvatar(
                      radius: AppSize.s22,
                      backgroundColor:
                          value.text.isNotEmpty ? AppColors.blue : Colors.grey,
                      child: loadingCondition
                          ? CustomCircleIndicator(
                              size: AppSize.s16,
                              color: AppColors.white,
                              strokeWidth: 1,
                            )
                          : Icon(
                              IconBroken.Send,
                              size: AppSize.s22,
                              color: value.text.isNotEmpty
                                  ? Colors.white
                                  : AppColors.lightBlack,
                            ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
