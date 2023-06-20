import 'package:contacts_service/contacts_service.dart';
import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/contacts/cubit/contacts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

AppBar buildAddContactAppBar() {
  return AppBar(
    titleSpacing: 0,
    title: LargeHeadText(
      text: "Add Contact",
      size: FontSize.s17,
      letterSpacing: 1,
    ),
    leading: Builder(builder: (context) {
      return IconButton(
        onPressed: () {
          Go.back(context: context);
        },
        icon: Icon(
          IconBroken.Arrow___Left_2,
          size: AppSize.s18,
        ),
      );
    }),
    actions: [
      BlocConsumer<ContactsCubit, ContactsState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = ContactsCubit.get(context);
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: AppWidth.w5),
            child: IconButton(
                onPressed: () {
                  if (cubit.formKey.currentState!.validate()) {
                    Contact contact = Contact(
                        givenName: cubit.firstNameController!.text,
                        familyName: cubit.lastNameController!.text,
                        phones: [
                          Item(
                              label: 'mobile',
                              value: cubit.phoneController!.text)
                        ],
                        company: cubit.companyController!.text,
                        emails: [
                          Item(
                              label: cubit.emailController!.text,
                              value: cubit.emailController!.text)
                        ]);
                    cubit.addNewContact(contact: contact, context: context);
                    print("A7A");
                  }
                },
                icon: state.maybeWhen(
                  addContactLoading: () => CustomCircleIndicator(
                    size: AppSize.s20,
                  ),
                  orElse: () => const Icon(
                    IconBroken.Add_User,
                    color: AppColors.blue,
                  ),
                )

                // state is! AppLoadingState?

                //     :
                // DefaultButtonLoader(size: 15.sp, width: 1.5.sp, color: AppColors.blue),
                // iconSize: AppSize.s20,
                ),
          );
        },
      )
    ],
  );
}
