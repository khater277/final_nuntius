import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stories_state.dart';
part 'stories_cubit.freezed.dart';

class StoriesCubit extends Cubit<StoriesState> {
  StoriesCubit() : super(StoriesState.initial());
}
