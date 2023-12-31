import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/sliver_scrollable_view.dart';
import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/contacts/cubit/contacts_cubit.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/contacts/add_new_contact.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/contacts/contacts_items.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/contacts/no_contacts_founded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactsCubit, ContactsState>(
      listener: (context, state) {
        state.maybeWhen(
          getContactsError: () => errorSnackBar(
              context: context,
              errorMsg: "there is some conflicts to get your contacts."),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = ContactsCubit.get(context);
        return state.maybeWhen(
          getContactsLoading: () =>
              const Center(child: CustomCircleIndicator()),
          getContactsError: () =>
              const Center(child: LargeHeadText(text: "ERROR")),
          orElse: () => SliverScrollableView(
            isScrollable: cubit.users.isNotEmpty,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppHeight.h16),
                const NewContact(),
                SizedBox(height: AppHeight.h16),
                const LargeHeadText(
                  text: "Contacts",
                  letterSpacing: 2,
                ),
                if (cubit.users.isNotEmpty)
                  ContactsItems(users: cubit.users)
                else
                  const NoContactsFounded(),
              ],
            ),
          ),
        );
      },
    );
  }
}
