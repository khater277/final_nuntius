import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:final_nuntius/features/stories/data/models/viewer_model/viewer_model.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/story_view/my_story_viewers/my_story_viewers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryViewBody extends StatelessWidget {
  const StoryViewBody({
    super.key,
    required this.cubit,
  });

  final StoriesCubit cubit;

  @override
  Widget build(BuildContext context) {
    final List<ViewerModel> viewers = [
      // ViewerModel(
      //   id: "123",
      //   phoneNumber: "123454",
      //   dateTime: DateTime.now().toString(),
      // ),
      // ViewerModel(
      //   id: "123",
      //   phoneNumber: "123454",
      //   dateTime: DateTime.now().toString(),
      // ),
      // ViewerModel(
      //   id: "123",
      //   phoneNumber: "123454",
      //   dateTime: DateTime.now().toString(),
      // ),
    ];
    return Expanded(
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          StoryView(
              storyItems: cubit.storyItems,
              controller: cubit.storyController!,
              onStoryShow: (story) {
                final index = cubit.storyItems.indexOf(story);
                cubit.changeStoryIndex(index: index);
                // debugPrint(index.toString());
                // if(widget.storiesIDs!=null){
                //   List<ViewerModel> viewers = widget.stories[index].viewers!;
                //   //contains(viewers.firstWhere((element) => element.id==uId))==false
                //   if(viewers.firstWhereOrNull((element) => element.id==uId)==null){
                //     viewers.add(ViewerModel(
                //       id: uId,
                //       phoneNumber: cubit.userModel!.phone,
                //       dateTime: DateTime.now().toString()
                //     ));
                //     cubit.viewStory(
                //         userID: widget.userID,
                //         storyID: widget.storiesIDs![index],
                //         viewers: viewers,
                //         isLast: index==storyItems.length-1
                //     );
                //   }
                //   debugPrint("${index==storyItems.length-1}");
                //   debugPrint(widget.storiesIDs![index]);
                // }
                // cubit.changeStoryIndex(index: index,);
                // print(s.duration);
              },
              onComplete: () {
                debugPrint("COMPLETED");
                // Go.back(context: context);
                // cubit.resetStoryIndex();
              },
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Go.back(context: context);
                }
              }),
          // LargeHeadText(text: "text"),
          MyStoryViewers(viewers: viewers),
        ],
      ),
    );
  }
}
