import 'package:final_nuntius/core/shared_widgets/sliver_app_bar.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/chats/cubit/chats_cubit.dart';
import 'package:final_nuntius/features/chats/presentation/widgets/chat_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsCubit, ChatsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: CustomScrollView(
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
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ChatBuilder(index: index);
                              },
                              separatorBuilder: (context, index) => Divider(
                                    color: AppColors.grey.withOpacity(0.08),
                                  ),
                              itemCount: 10),
                        )
                      ],
                    )),
              )
            ],
          ),
        );
      },
    );
  }
}
