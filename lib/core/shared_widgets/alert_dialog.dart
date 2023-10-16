import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:flutter/material.dart';

Future<T?> showAlertDialog<T>({
  required BuildContext context,
  required String text,
  required void Function()? okPressed,
  bool loadingCondition = false,
}) {
  AlertDialog alert = AlertDialog(
    backgroundColor: AppColors.lightBlack,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSize.s10),
    ),
    content: SmallHeadText(
      text: text,
      size: FontSize.s13,
      maxLines: 3,
      center: true,
    ),
    contentPadding: EdgeInsets.only(
      top: AppHeight.h20,
      bottom: AppHeight.h5,
      right: AppWidth.w15,
      left: AppWidth.w15,
    ),
    actionsPadding: EdgeInsets.only(bottom: AppHeight.h8, top: AppHeight.h5),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextButton(
              child: const Text("Cancel"),
              onPressed: () => Go.back(context: context),
            ),
          ),
          Expanded(
            child: loadingCondition
                ? Center(
                    child: CustomCircleIndicator(
                    size: AppSize.s15,
                    strokeWidth: 1.2,
                  ))
                : TextButton(
                    onPressed: okPressed,
                    child: const Text("Ok"),
                  ),
          ),
        ],
      ),
    ],
  );

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
