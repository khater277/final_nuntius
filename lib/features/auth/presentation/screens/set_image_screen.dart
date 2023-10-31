import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/auth/cubit/auth_cubit.dart';
import 'package:final_nuntius/features/auth/presentation/widgets/set_image/image_view.dart';
import 'package:final_nuntius/features/auth/presentation/widgets/set_image/name_text_field.dart';
import 'package:final_nuntius/features/auth/presentation/widgets/set_image/set_image_head.dart';
import 'package:final_nuntius/features/auth/presentation/widgets/set_image/set_image_next_button.dart';
import 'package:final_nuntius/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetImageScreen extends StatefulWidget {
  const SetImageScreen({Key? key}) : super(key: key);

  @override
  State<SetImageScreen> createState() => _SetImageScreenState();
}

class _SetImageScreenState extends State<SetImageScreen> {
  late AuthCubit authCubit;

  @override
  void initState() {
    authCubit = AuthCubit.get(context);
    authCubit.initNameController();
    super.initState();
  }

  @override
  void dispose() {
    authCubit.disposeNameController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          addUserToFirestoreError: (errorMsg) =>
              errorSnackBar(context: context, errorMsg: errorMsg),
          uploadImageToStorageError: (errorMsg) =>
              errorSnackBar(context: context, errorMsg: errorMsg),
          addUserToFirestore: () =>
              Go.off(context: context, screen: const HomeScreen()),
          updateUserToken: () =>
              Go.off(context: context, screen: const HomeScreen()),
          orElse: () {},
        );
      },
      builder: (context, state) {
        AuthCubit cubit = AuthCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            actions: [
              TextButton(
                onPressed: () {
                  cubit.addUserToFirestore();
                },
                child: state.maybeWhen(
                  addUserToFirestoreLoading: () =>
                      CustomCircleIndicator(size: AppSize.s18, strokeWidth: 1),
                  orElse: () => const LargeHeadText(
                    text: "SKIP",
                    color: AppColors.blue,
                  ),
                ),
              )
            ],
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppWidth.w5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        const SetImageHead(),
                        SizedBox(height: AppHeight.h15),
                        ImageView(cubit: cubit),
                        SizedBox(height: AppHeight.h30),
                        NameTextField(nameController: cubit.nameController!),
                      ],
                    ),
                    SizedBox(
                      height: AppHeight.h30,
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: const SetImageNextButton(),
        );
      },
    );
  }
}
