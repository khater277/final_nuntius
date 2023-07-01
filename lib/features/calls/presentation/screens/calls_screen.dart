import 'package:final_nuntius/core/shared_widgets/sliver_scrollable_view.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/calls/presentation/widgets/call_name_and_caption.dart';
import 'package:final_nuntius/features/calls/presentation/widgets/call_status_icon.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/contacts/user_image.dart';
import 'package:flutter/material.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<CallStatus> status = [
      CallStatus.inComing,
      CallStatus.outComing,
      CallStatus.inComingNoResponse,
      CallStatus.outComingNoResponse,
      CallStatus.inComing,
      CallStatus.outComing,
      CallStatus.inComingNoResponse,
      CallStatus.outComingNoResponse,
      CallStatus.inComing,
      CallStatus.outComing,
    ];
    return SliverScrollableView(
      hasScrollBody: true,
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: status.length,
          itemBuilder: (BuildContext context, int index) => Padding(
                padding: EdgeInsets.symmetric(vertical: AppHeight.h10),
                child: Row(
                  children: [
                    const UserImage(image: ''),
                    SizedBox(width: AppWidth.w5),
                    CallsNameAndCaption(
                      callType: CallType.voice,
                      callStatus: status[index],
                    ),
                    CallStatusIcon(callStatus: status[index]),
                  ],
                ),
              )),
    );
  }
}
