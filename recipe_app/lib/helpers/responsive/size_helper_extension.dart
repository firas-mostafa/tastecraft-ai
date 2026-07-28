import 'dart:io' show Platform;
import 'dart:math' show min;

import 'package:flutter/material.dart'
    show BuildContext, Orientation, MediaQuery;
import 'package:recipe_app/helpers/responsive/size_provider.dart'
    show SizeProvider;

extension SizeHelperExtension on BuildContext {
  bool get isLandscape {
    if (Platform.isAndroid || Platform.isIOS) {
      return MediaQuery.of(this).orientation == Orientation.landscape;
    }
    return false;
  }

  double get screenWidth => isLandscape
      ? MediaQuery.of(this).size.height
      : MediaQuery.of(this).size.width;

  double get screenHeight => isLandscape
      ? MediaQuery.of(this).size.width
      : MediaQuery.of(this).size.height;

  SizeProvider get sizeProvider => SizeProvider.of(this);

  double get scaleHeight => sizeProvider.hight / sizeProvider.baseSize.height;
  double get scaleWidth => sizeProvider.width / sizeProvider.baseSize.width;

  double setWidth(num w) => w * scaleWidth;
  double setHeight(num h) => h * scaleHeight;

  // double setSp(num fontSize) => fontSize * scaleWidth;
  double setMineSize(num size) => size * min(scaleHeight, scaleWidth);
}
