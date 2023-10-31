import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/auth/cubit/auth_cubit.dart';
import 'package:final_nuntius/features/auth/presentation/screens/otp_screen.dart';
import 'package:final_nuntius/features/auth/presentation/widgets/login/flag_and_country_code.dart';
import 'package:final_nuntius/features/auth/presentation/widgets/login/login_head.dart';
import 'package:final_nuntius/features/auth/presentation/widgets/login/login_next_button.dart';
import 'package:final_nuntius/features/auth/presentation/widgets/login/phone_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthCubit authCubit;
  @override
  void initState() {
    authCubit = AuthCubit.get(context);
    authCubit.initPhoneController();
    super.initState();
  }

  @override
  void dispose() {
    authCubit.disposePhoneController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          codeSent: () => Go.to(
            context: context,
            screen: OtpScreen(
              phoneNumber: authCubit.phoneController!.text,
            ),
          ),
          errorState: (errorMsg) =>
              errorSnackBar(context: context, errorMsg: errorMsg),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = AuthCubit.get(context);
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
                    const LoginHead(),
                    SizedBox(height: AppHeight.h100),
                    Row(
                      children: [
                        const FlagAndCountryCode(),
                        SizedBox(width: AppWidth.w8),
                        PhoneTextField(controller: cubit.phoneController!)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: const LoginNextButton(),
          ),
        );
      },
    );
  }
}
