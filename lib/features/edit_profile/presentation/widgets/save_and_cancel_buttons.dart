import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:flutter/material.dart';

class SaveAndCancelButtons extends StatelessWidget {
  final TextEditingController nameController;
  const SaveAndCancelButtons({Key? key, required this.nameController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("===============>${EditProfileCubit.get(context).state.toString()}");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () => Go.back(context: context),
          child: const Text("CANCEL"),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: nameController,
          builder: (BuildContext context, value, Widget? child) {
            if (EditProfileCubit.get(context).state ==
                const EditProfileState.updateProfileNameLoading()) {
              return CustomCircleIndicator(
                strokeWidth: 1,
                size: AppSize.s18,
              );
            } else {
              return TextButton(
                onPressed: () =>
                    nameController.text != HiveHelper.getCurrentUser()!.name
                        ? EditProfileCubit.get(context)
                            .updateProfileName(name: nameController.text)
                        : () {},
                child: const Text("SAVE"),
              );
            }
          },
        ),
      ],
    );
  }
}
