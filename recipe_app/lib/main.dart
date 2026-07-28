import 'dart:io' show Platform;
import 'package:dio/dio.dart' show Dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, MultiBlocProvider, WatchContext;
import 'package:recipe_app/data/repositories/recipe_repository.dart'
    show RecipeRepository;
import 'package:recipe_app/logic/recipe_cubit/recipe_cubit.dart'
    show RecipeCubit;
import 'package:recipe_app/core/api/dio_consumer.dart' show DioConsumer;
import 'package:recipe_app/data/repositories/user_repository.dart'
    show UserRepository;
import 'package:recipe_app/data/repositories/meal_plan_repository.dart'
    show MealPlanRepository;
import 'package:recipe_app/logic/meal_plan_cubit/meal_plan_cubit.dart'
    show MealPlanCubit;
import 'package:recipe_app/presentation/home/logic/ai_calorie_cubit/ai_calorie_cubit.dart'
    show AiCalorieCubit;
import 'package:recipe_app/helpers/theme/app_themes.dart' show AppThemes;
import 'package:recipe_app/helpers/theme/logic/theme_cubit.dart'
    show ThemeCubit;
import 'package:recipe_app/presentation/splash/screens/splash_screen.dart'
    show SplashScreen;
import 'package:window_size/window_size.dart'
    as window_size
    show setWindowMinSize;
import 'package:recipe_app/helpers/cache/cache_helper.dart' show CacheHelper;
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/responsive/size_provider.dart'
    show SizeProvider;
import 'package:recipe_app/helpers/routes/app_router.dart' show AppRouter;
import 'package:recipe_app/helpers/theme/text_theme.dart' show createTextTheme;
import 'package:recipe_app/logic/user_cubit/user_cubit.dart' show UserCubit;

import 'package:recipe_app/logic/locale_cubit/locale_cubit.dart'
    show LocaleCubit;
import 'package:recipe_app/l10n/app_localizations.dart';
import 'package:recipe_app/presentation/widgets/connectivity_wrapper.dart' show ConnectivityWrapper;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper().init();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    window_size.setWindowMinSize(const Size(400, 700));
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(cacheHelper: CacheHelper()),
        ),
        BlocProvider<LocaleCubit>(
          create: (context) => LocaleCubit(cacheHelper: CacheHelper()),
        ),
        BlocProvider<UserCubit>(
          create: (context) =>
              UserCubit(UserRepository(DioConsumer(dio: Dio()))),
        ),
        BlocProvider<RecipeCubit>(
          create: (context) =>
              RecipeCubit(RecipeRepository(DioConsumer(dio: Dio()))),
        ),
        BlocProvider<MealPlanCubit>(
          create: (context) =>
              MealPlanCubit(mealPlanRepository: MealPlanRepository(DioConsumer(dio: Dio()))),
        ),
        BlocProvider<AiCalorieCubit>(
          create: (context) =>
              AiCalorieCubit(RecipeRepository(DioConsumer(dio: Dio()))),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return SizeProvider(
      baseSize: Size(469, 1018),
      width: context.screenWidth,
      hight: context.screenHeight,
      child: Builder(
        builder: (context) {
          TextTheme textTheme = createTextTheme(
            context,
            "ABeeZee",
            "ADLaM Display",
          );
          return MaterialApp(
            locale: context.watch<LocaleCubit>().state,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            themeMode: context.watch<ThemeCubit>().state.themeMode,
            darkTheme: AppThemes(textTheme).dark(),
            theme: AppThemes(textTheme).light(),
            themeAnimationCurve: Curves.easeInOut,
            themeAnimationDuration: Duration(milliseconds: 300),
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
            onGenerateRoute: AppRouter().onGenerateRoute,
            builder: (context, child) {
              return ConnectivityWrapper(child: child!);
            },
          );
        },
      ),
    );
  }
}
