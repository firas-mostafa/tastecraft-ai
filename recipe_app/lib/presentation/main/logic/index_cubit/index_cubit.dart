import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;

part 'index_state.dart';

class IndexCubit extends Cubit<IndexState> {
  IndexCubit() : super(IndexState(0));

  void changeIndex(int value) {
    emit(IndexState(value));
  }
}
