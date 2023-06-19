import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/features/auth/cubit/auth_cubit.dart';
import 'package:final_nuntius/features/auth/presentation/widgets/auth_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginNextButton extends StatelessWidget {
  const LoginNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final cubit = AuthCubit.get(context);
        return ValueListenableBuilder(
          valueListenable: cubit.phoneController!,
          builder: (BuildContext context, value, Widget? child) {
            return AuthFloatingButton(
              visibleCondition: value.text.length == 11,
              loadingCondition:
                  state == const AuthState.signInWithPhoneNumberLoading(),
              onPressed: () {
                String? msg;
                final text = value.text;
                if (text.isEmpty) {
                  msg = "phone number cant be empty";
                } else if (text.startsWith('01') == false) {
                  msg = "incorrect number it should start by 01";
                } else if (text.length != 11) {
                  msg = "invalid phone number it should be 11 digit";
                }
                if (msg != null) {
                  showSnackBar(
                    context: context,
                    message: msg,
                    color: AppColors.red,
                  );
                } else {
                  // cubit.getUser();
                  cubit.signInWithPhoneNumber();
                }
              },
            );
          },
        );
      },
    );
  }
}
