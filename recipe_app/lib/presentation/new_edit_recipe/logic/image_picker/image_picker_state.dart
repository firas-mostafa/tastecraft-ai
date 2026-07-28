part of 'image_picker_cubit.dart';

class ImagePickerState extends Equatable {
  const ImagePickerState(this.image);
  final XFile? image;
  @override
  List<Object> get props => [image ?? 0];
}
