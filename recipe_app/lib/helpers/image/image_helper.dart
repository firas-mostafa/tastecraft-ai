import 'package:recipe_app/core/api/end_ponits.dart';

class ImageHelper {
  static String imageBase = 'assets/images/';
  static String iconBase = 'assets/icons/';

  static String logoDark = '${imageBase}logo_dark.svg';
  static String logoLight = '${imageBase}logo_light.svg';

  static String profilePic = '${imageBase}profile.jpg';

  static String fixImageUrl(String url) {
    return url.replaceFirst('http://localhost:8000/', EndPoint.baseUrl);
  }
}
