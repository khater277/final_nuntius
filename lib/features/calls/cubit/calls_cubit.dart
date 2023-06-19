import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:final_nuntius/features/calls/data/repositories/calls_repository.dart';

part 'calls_cubit.freezed.dart';
part 'calls_state.dart';

class CallsCubit extends Cubit<CallsState> {
  final CallsRepository callsRepository;
  CallsCubit({required this.callsRepository})
      : super(const CallsState.initial());

  static CallsCubit get(context) => BlocProvider.of(context);

  void generateToken() async {
    emit(const CallsState.generateTokenLoading());
    final response = await callsRepository.generateToken();
    response.fold(
      (failure) {
        emit(CallsState.generateTokenError(failure.getMessage()));
      },
      (token) {
        emit(CallsState.generateTokenSuccess(token));
      },
    );
  }
}
