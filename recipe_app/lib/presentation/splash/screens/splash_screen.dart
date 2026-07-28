import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:recipe_app/core/api/end_ponits.dart' show ApiKey;
import 'package:recipe_app/helpers/cache/cache_helper.dart' show CacheHelper;
import 'package:recipe_app/helpers/image/image_helper.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    final String? token = CacheHelper().getDataString(ApiKey.token);
    final bool isLoggedIn = token != null && token.isNotEmpty;
    if (mounted) {
      Navigator.pushReplacementNamed(context, isLoggedIn ? '' : 'login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.primary,
      body: Center(
        child: SvgPicture.asset(
          ImageHelper.logoLight,
          colorFilter: ColorFilter.mode(
            context.colorScheme.onPrimary,
            BlendMode.srcIn,
          ),
          width: context.setMineSize(200),
        ),
      ),
    );
  }
}
