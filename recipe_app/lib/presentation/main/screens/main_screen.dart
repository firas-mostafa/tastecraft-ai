import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/presentation/meal_plan/screens/meal_plan_screen.dart'
    show MealPlanScreen;
import 'package:recipe_app/presentation/profile/screens/profile.dart'
    show Profile;
import 'package:recipe_app/presentation/main/logic/index_cubit/index_cubit.dart'
    show IndexCubit;
import 'package:recipe_app/presentation/home/screens/home.dart' show Home;
import 'package:recipe_app/presentation/main/widgets/bottom_nav_bar.dart'
    show BottomNavBar;
import 'package:recipe_app/l10n/app_localizations.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<IconData> icons = [
      Icons.home_rounded,
      Icons.calendar_month_rounded,
      Icons.person_outline_rounded,
    ];
    final l10n = AppLocalizations.of(context)!;
    List<String> titles = [l10n.homeTab, l10n.mealPlanTab, l10n.profileTab];
    List<Widget> screens = [const Home(), const MealPlanScreen(), const Profile()];
    return BlocProvider(
      create: (context) => IndexCubit(),
      child: Scaffold(
        body: Builder(
          builder: (indexContext) {
            return screens[indexContext.watch<IndexCubit>().state.indexValue];
          },
        ),
        resizeToAvoidBottomInset: false,
        floatingActionButton: BottomNavBar(icons, titles),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
