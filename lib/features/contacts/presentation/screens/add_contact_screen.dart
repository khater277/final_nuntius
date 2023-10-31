import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/contacts/cubit/contacts_cubit.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/add_contact/add_contact_app_bar.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/add_contact/add_contact_company_text_field.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/add_contact/add_contact_email_text_field.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/add_contact/add_contact_first_and_last_names_text_fields.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/add_contact/add_contact_phone_text_field.dart';
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
          addContactError: (errorMsg) =>
              errorSnackBar(context: context, errorMsg: errorMsg),
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
                      AddContactFirstAndLastNamesTextFields(
                        firstNameController: cubit.firstNameController!,
                        lastNameController: cubit.lastNameController!,
                      ),
                      SizedBox(height: AppHeight.h15),
                      AddContactPhoneTextField(
                          phoneController: cubit.phoneController!),
                      SizedBox(height: AppHeight.h15),
                      AddContactEmailTextField(
                          emailController: cubit.emailController!),
                      SizedBox(height: AppHeight.h15),
                      AddContactCompanyTextField(
                          companyController: cubit.companyController!),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
