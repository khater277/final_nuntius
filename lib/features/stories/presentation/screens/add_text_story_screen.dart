import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/back_button.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/add_text_story/send_story_button.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/add_text_story/story_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTextStoryScreen extends StatefulWidget {
  const AddTextStoryScreen({Key? key}) : super(key: key);

  @override
  State<AddTextStoryScreen> createState() => _AddTextStoryScreenState();
}

class _AddTextStoryScreenState extends State<AddTextStoryScreen> {
  late StoriesCubit storiesCubit;
  @override
  void initState() {
    storiesCubit = StoriesCubit.get(context);
    storiesCubit.initAddTextStory();
    super.initState();
  }

  @override
  void dispose() {
    storiesCubit.disposeAddTextStory();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoriesCubit, StoriesState>(
      listener: (context, state) {
        state.maybeWhen(
          sendStoryError: (errorMsg) => showSnackBar(
            context: context,
            message: errorMsg,
            color: AppColors.red,
          ),
          sendStory: () => Go.back(context: context),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = StoriesCubit.get(context);
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(leading: const CustomBackButton()),
            body: state.maybeWhen(
              sendStoryLoading: () =>
                  const Center(child: CustomCircleIndicator()),
              getFilePercentage: () =>
                  const Center(child: CustomCircleIndicator()),
              orElse: () => Padding(
                padding: EdgeInsets.only(top: AppHeight.h6),
                child: StoryTextField(controller: cubit.controller!),
              ),
            ),
            floatingActionButton: SendStoryButton(
              controller: cubit.controller!,
              storyType: MessageType.text,
            ),
          ),
        );
      },
    );
  }
}
