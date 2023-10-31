import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/no_items_founded.dart';
import 'package:final_nuntius/core/shared_widgets/sliver_scrollable_view.dart';
import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/calls/cubit/calls_cubit.dart';
import 'package:final_nuntius/features/calls/presentation/widgets/calls/calls_items.dart';
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
    return BlocBuilder<CallsCubit, CallsState>(
      builder: (context, state) {
        final cubit = CallsCubit.get(context);
        return state.maybeWhen(
          initCalls: () => const Center(child: CustomCircleIndicator()),
          getCallsLoading: () => const Center(child: CustomCircleIndicator()),
          getCallsError: (errorMsg) =>
              errorSnackBar(context: context, errorMsg: errorMsg),
          orElse: () => SliverScrollableView(
            isScrollable: cubit.calls!.isNotEmpty,
            child: cubit.calls!.isEmpty
                ? const NoItemsFounded(
                    text:
                        'there is no calls yet, keep in touch with your friends and call them now.',
                    icon: IconBroken.Call,
                  )
                : CallsItems(calls: cubit.calls!),
          ),
        );
      },
    );
  }
}
