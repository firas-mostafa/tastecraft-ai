import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;

part 'obscure_state.dart';

class ObscureCubit extends Cubit<ObscureState> {
  ObscureCubit() : super(ObscureState(true));

  void obscureChange() =>
      state.obscure ? emit(ObscureState(false)) : emit(ObscureState(true));
}
