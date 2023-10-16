import 'package:final_nuntius/core/shared_widgets/back_button.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/chats/cubit/chats_cubit.dart';
import 'package:final_nuntius/features/messages/cubit/messages_cubit.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/app_bar/call_button.dart';
import 'package:flutter/material.dart';

AppBar messagesAppBar({required String name}) {
  return AppBar(
    toolbarHeight: AppHeight.h60,
    backgroundColor: AppColors.darkBlack,
    centerTitle: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(AppSize.s20),
      bottomRight: Radius.circular(AppSize.s20),
    )),
    title: LargeHeadText(
      text: name,
      size: FontSize.s15,
    ),
    leading: Builder(builder: (context) {
      MessagesCubit.get(context)
          .readMessage(lastMessages: ChatsCubit.get(context).lastMessages);
      return const CustomBackButton();
    }),
    actions: [
      Padding(
          padding: EdgeInsets.symmetric(horizontal: AppWidth.w5),
          child: const Row(
            children: [
              CallButton(callType: CallType.voice),
              CallButton(callType: CallType.video),
            ],
          ))
    ],
  );
}
