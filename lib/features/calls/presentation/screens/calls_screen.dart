import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/no_items_founded.dart';
import 'package:final_nuntius/core/shared_widgets/sliver_scrollable_view.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/calls/cubit/calls_cubit.dart';
import 'package:final_nuntius/features/calls/presentation/widgets/calls/call_name_and_caption.dart';
import 'package:final_nuntius/features/calls/presentation/widgets/calls/call_status_icon.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/contacts/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CallsScreen extends StatefulWidget {
  const CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  @override
  void initState() {
    CallsCubit.get(context).getCalls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CallsCubit, CallsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = CallsCubit.get(context);
        return state.maybeWhen(
          initCalls: () => const Center(child: CustomCircleIndicator()),
          getCallsLoading: () => const Center(child: CustomCircleIndicator()),
          getCallsError: (errorMsg) => Center(
              child: LargeHeadText(
            text: errorMsg,
            maxLines: 4,
          )),
          orElse: () => SliverScrollableView(
            isScrollable: cubit.calls!.isNotEmpty,
            child: cubit.calls!.isEmpty
                ? const NoItemsFounded(
                    text:
                        'there is no calls yet, keep in touch with your friends and call them now.',
                    icon: IconBroken.Call,
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cubit.calls!.length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: AppHeight.h15),
                          child: Row(
                            children: [
                              UserImage(
                                image: cubit.calls![index].image!,
                                isCalls: true,
                              ),
                              SizedBox(width: AppWidth.w5),
                              CallsNameAndCaption(
                                callType:
                                    cubit.calls![index].callModel!.callType!,
                                callStatus:
                                    cubit.calls![index].callModel!.callStatus!,
                                name: cubit.calls![index].name!,
                                date: cubit.calls![index].callModel!.dateTime!,
                              ),
                              CallStatusIcon(
                                  callStatus: cubit
                                      .calls![index].callModel!.callStatus!),
                            ],
                          ),
                        )),
          ),
        );
      },
    );
  }
}
