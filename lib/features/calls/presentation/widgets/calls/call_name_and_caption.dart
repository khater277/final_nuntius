import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CallsNameAndCaption extends StatelessWidget {
  final CallType callType;
  final CallStatus callStatus;
  final String name;
  final String date;
  const CallsNameAndCaption({
    Key? key,
    required this.callType,
    required this.callStatus,
    required this.name,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String status;

    switch (callStatus) {
      case CallStatus.inComing:
        status = 'incoming';
        break;
      case CallStatus.outComing:
        status = 'outcoming';
        break;
      case CallStatus.inComingNoResponse:
        status = 'missed';
        break;
      default:
        status = 'no response';
        break;
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LargeHeadText(
            text: ' $name',
            size: FontSize.s13,
          ),
          SizedBox(height: AppHeight.h3),
          Row(
            children: [
              Icon(
                callType == CallType.video ? IconBroken.Video : IconBroken.Call,
                color: AppColors.blue,
                size: AppSize.s12,
              ),
              SizedBox(
                width: AppWidth.w5,
              ),
              Flexible(
                child: SecondaryText(
                    text:
                        "$status - ${DateFormat('yyyy/MM/dd').format(DateTime.parse(date).toLocal())} at ${DateFormat.jm().format(DateTime.parse(date).toLocal())}",
                    size: FontSize.s12),
              ),
              SizedBox(
                width: AppWidth.w2,
              ),
            ],
          )
        ],
      ),
    );
  }
}
