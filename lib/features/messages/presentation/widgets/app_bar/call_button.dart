import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:flutter/material.dart';

class CallButton extends StatelessWidget {
  final CallType callType;

  const CallButton({Key? key, required this.callType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: Icon(
          callType == CallType.video ? IconBroken.Video : IconBroken.Call,
          color: AppColors.blue,
          size: AppSize.s20,
        ));
  }
}
