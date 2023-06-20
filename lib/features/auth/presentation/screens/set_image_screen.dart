import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/shared_widgets/text_form_field.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/auth/cubit/auth_cubit.dart';
import 'package:final_nuntius/features/auth/presentation/widgets/set_image/image_view.dart';
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
          addUserToFirestoreError: (errorMsg) => showSnackBar(
            context: context,
            message: errorMsg,
            color: AppColors.red,
          ),
          uploadImageToStorageError: (errorMsg) => showSnackBar(
            context: context,
            message: errorMsg,
            color: AppColors.red,
          ),
          addUserToFirestore: () => Go.off(
            context: context,
            screen: const HomeScreen(),
          ),
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
                  if (HiveHelper.getCurrentUser() == null) {
                    cubit.addUserToFirestore();
                  } else {
                    Go.off(context: context, screen: const HomeScreen());
                  }
                },
                child: const LargeHeadText(
                  text: "SKIP",
                  color: AppColors.blue,
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
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: AppWidth.w20),
                          child: CustomTextField(
                            hintText: "enter your name..",
                            controller: cubit.nameController!,
                            inputType: TextInputType.name,
                          ),
                        ),
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
