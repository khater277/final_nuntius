import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/auth/cubit/auth_cubit.dart';
import 'package:final_nuntius/features/auth/presentation/screens/set_image_screen.dart';
import 'package:final_nuntius/features/auth/presentation/widgets/otp/otp_fields.dart';
import 'package:final_nuntius/features/auth/presentation/widgets/otp/otp_head.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpScreen extends StatelessWidget {
  final String phoneNumber;
  const OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          submitOtp: () => Go.offAll(
            context: context,
            screen: const SetImageScreen(),
          ),
          errorState: (errorMsg) =>
              errorSnackBar(context: context, errorMsg: errorMsg),
          orElse: () {},
        );
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppHeight.h60,
                  horizontal: AppWidth.w20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OtpHead(phoneNumber: phoneNumber),
                    SizedBox(height: AppHeight.h50),
                    state.maybeWhen(
                      submitOtpLoading: () => Center(
                        child: CustomCircleIndicator(
                          color: AppColors.blue,
                          size: AppSize.s40,
                        ),
                      ),
                      orElse: () => const OtpFields(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
