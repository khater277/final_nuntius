import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/features/auth/cubit/auth_cubit.dart';
import 'package:final_nuntius/features/auth/presentation/widgets/auth_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetImageNextButton extends StatelessWidget {
  const SetImageNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final cubit = AuthCubit.get(context);
        return ValueListenableBuilder<TextEditingValue>(
            valueListenable: cubit.nameController!,
            builder: (BuildContext context, value, Widget? child) {
              return AuthFloatingButton(
                visibleCondition: (cubit.profileImage != null ||
                    (HiveHelper.getCurrentUser() != null &&
                        value.text != HiveHelper.getCurrentUser()!.name)),
                loadingCondition:
                    state == const AuthState.addUserToFirestoreLoading() ||
                        state == const AuthState.uploadImageToStorageLoading(),
                onPressed: () {
                  // print("asdfghjkl");
                  if (cubit.profileImage != null) {
                    cubit.uploadImageToStorage();
                  } else {
                    cubit.addUserToFirestore();
                  }
                },
              );
            });
      },
    );
  }
}
