import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:final_nuntius/features/edit_profile/presentation/widgets/app_bar.dart';
import 'package:final_nuntius/features/edit_profile/presentation/widgets/my_name.dart';
import 'package:final_nuntius/features/edit_profile/presentation/widgets/my_phone_number.dart';
import 'package:final_nuntius/features/edit_profile/presentation/widgets/my_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    EditProfileCubit.get(context).initEditProfileScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        state.maybeWhen(
          updateProfileName: () => Go.back(context: context),
          pickProfileImageError: (errorMsg) =>
              errorSnackBar(context: context, errorMsg: errorMsg),
          updateProfileNameError: (errorMsg) =>
              errorSnackBar(context: context, errorMsg: errorMsg),
          updateProfileImageError: (errorMsg) =>
              errorSnackBar(context: context, errorMsg: errorMsg),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = EditProfileCubit.get(context);
        return Scaffold(
          appBar: editProfileAppBar(cubit: cubit, state: state),
          body: Padding(
            padding: EdgeInsets.symmetric(
                vertical: AppHeight.h8, horizontal: AppWidth.w10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MyProfileImage(image: HiveHelper.getCurrentUser()!.image!),
                  SizedBox(height: AppHeight.h6),
                  if (state ==
                          const EditProfileState.updateProfileImageLoading() ||
                      state ==
                          const EditProfileState.getProfileImagePercentage())
                    LinearProgressIndicator(
                      value: cubit.profileImagePercentage,
                      minHeight: 2,
                      color: AppColors.blue.withOpacity(0.7),
                      backgroundColor: AppColors.lightBlack,
                    ),
                  SizedBox(height: AppHeight.h8),
                  MyName(name: HiveHelper.getCurrentUser()!.name!),
                  SizedBox(height: AppHeight.h8),
                  MyPhoneNumber(phone: HiveHelper.getCurrentUser()!.phone!)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
