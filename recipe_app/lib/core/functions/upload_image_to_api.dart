import 'package:dio/dio.dart' show MultipartFile;
import 'package:image_picker/image_picker.dart' show XFile;

Future uploadImageToAPI(XFile image) async {
  return MultipartFile.fromFile(
    image.path,
    filename: image.name,
  );
}
