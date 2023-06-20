import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/contacts/cubit/contacts_cubit.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/add_contact/add_contact_app_bar.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/add_contact/add_contact_text_field_and_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddContactsScreen extends StatefulWidget {
  const AddContactsScreen({super.key});

  @override
  State<AddContactsScreen> createState() => _AddContactsScreenState();
}

class _AddContactsScreenState extends State<AddContactsScreen> {
  late ContactsCubit contactsCubit;
  @override
  void initState() {
    contactsCubit = ContactsCubit.get(context);
    contactsCubit.initControllers();
    super.initState();
  }

  @override
  void dispose() {
    contactsCubit.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactsCubit, ContactsState>(
      listener: (context, state) {
        state.maybeWhen(
          addContact: () => showSnackBar(
            context: context,
            message: "${ContactsCubit.get(context).firstNameController!.text}"
                "${ContactsCubit.get(context).lastNameController!.text} added to your contacts",
            color: AppColors.blue,
          ),
          addContactError: (errorMsg) {
            showSnackBar(
              context: context,
              message: errorMsg,
              color: AppColors.red,
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = ContactsCubit.get(context);
        return Scaffold(
            appBar: buildAddContactAppBar(),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppWidth.w10),
              child: SingleChildScrollView(
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    children: [
                      SizedBox(height: AppHeight.h10),
                      Row(
                        children: [
                          Expanded(
                            child: AddContactTextFieldAndTitle(
                              controller: cubit.firstNameController!,
                              title: "First name",
                              hint: 'first name..',
                              inputType: TextInputType.name,
                              icon: IconBroken.Profile,
                              validator: (value) {
                                if (cubit.firstNameController!.text.isEmpty) {
                                  return """can't be empty""";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: AppWidth.w10),
                          Expanded(
                            child: AddContactTextFieldAndTitle(
                              controller: cubit.lastNameController!,
                              title: "Last name",
                              hint: 'last name..',
                              inputType: TextInputType.name,
                              icon: IconBroken.Profile,
                              validator: (value) {
                                if (cubit.lastNameController!.text.isEmpty) {
                                  return """can't be empty""";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppHeight.h15),
                      AddContactTextFieldAndTitle(
                        controller: cubit.phoneController!,
                        title: 'Phone number',
                        hint: 'phone number..',
                        inputType: TextInputType.phone,
                        icon: IconBroken.Call,
                        validator: (value) {
                          if (cubit.phoneController!.text.isEmpty) {
                            return """can't be empty""";
                          } else if (cubit.phoneController!.text.length != 11) {
                            return "invalid phone number";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppHeight.h15),
                      AddContactTextFieldAndTitle(
                        controller: cubit.emailController!,
                        title: 'Email',
                        hint: 'email address..',
                        inputType: TextInputType.emailAddress,
                        icon: IconBroken.Message,
                      ),
                      SizedBox(height: AppHeight.h15),
                      AddContactTextFieldAndTitle(
                        controller: cubit.companyController!,
                        title: 'Company',
                        hint: 'company..',
                        inputType: TextInputType.text,
                        icon: IconBroken.Work,
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
