import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/sliver_app_bar.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/contacts/cubit/contacts_cubit.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/add_new_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactsCubit, ContactsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = ContactsCubit.get(context);
        return Scaffold(
          body: state.maybeWhen(
            getContactsLoading: () =>
                const Center(child: CustomCircleIndicator()),
            getContactsError: () =>
                const Center(child: LargeHeadText(text: "ERROR")),
            orElse: () => CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const CustomSliverAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: AppWidth.w10,
                      left: AppWidth.w10,
                      top: AppHeight.h5,
                    ),
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
                        // SizedBox(height: AppHeight.h5),
                        // if(cubit.users.isNotEmpty)
                        Flexible(
                          fit: FlexFit.loose,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: cubit.users.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) =>
                                LargeHeadText(text: cubit.users[index].name!),
                          ),
                        ),
                        // else
                        //   const NoContactsFounded(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
