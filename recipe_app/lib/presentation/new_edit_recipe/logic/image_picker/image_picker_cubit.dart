import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:image_picker/image_picker.dart'
    show ImagePicker, ImageSource, XFile;

part 'image_picker_state.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  ImagePickerCubit() : super(ImagePickerState(null));
  void setImage() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      emit(ImagePickerState(value));
    });
  }

  void clear() {
    emit(ImagePickerState(null));
  }
}
