import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_strings.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetImageFloatingButton extends StatelessWidget {
  const SetImageFloatingButton({
    super.key,
    required this.cubit,
  });

  final AuthCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return ValueListenableBuilder<TextEditingValue>(
            valueListenable: cubit.nameController!,
            builder: (BuildContext context, value, Widget? child) {
              return (cubit.profileImage != null ||
                      (HiveHelper.getCurrentUser() != null &&
                          value.text != HiveHelper.getCurrentUser()!.name))
                  ? FloatingActionButton.extended(
                      onPressed: () {
                        if (cubit.profileImage != null) {
                          cubit.uploadImageToStorage();
                        } else {
                          cubit.addUserToFirestore();
                        }
                      },
                      label: state.maybeWhen(
                        addUserToFirestoreLoading: () => Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: AppWidth.w15),
                          child: CustomCircleIndicator(
                            color: AppColors.black,
                            size: AppSize.s20,
                          ),
                        ),
                        orElse: () => Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: AppWidth.w5),
                          child: Row(
                            children: [
                              SmallHeadText(
                                text: AppStrings.next,
                                color: AppColors.black,
                                size: FontSize.s15,
                              ),
                              SizedBox(width: AppWidth.w4),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.black,
                                size: AppSize.s12,
                              )
                            ],
                          ),
                        ),
                      ),
                      backgroundColor: AppColors.white,
                    )
                  : const SizedBox();
            });
      },
    );
  }
}
