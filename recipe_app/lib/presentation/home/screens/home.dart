import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/logic/user_cubit/user_cubit.dart';
import 'package:recipe_app/logic/recipe_cubit/recipe_cubit.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/presentation/home/widgets/recipe_list.dart' show RecipeList;
import 'package:recipe_app/presentation/home/widgets/tag_list.dart';
import 'package:recipe_app/presentation/home/widgets/search_filter.dart' show SearchFilter;
import 'package:recipe_app/presentation/home/widgets/search_and_ai_header_delegate.dart' show SearchAndAiHeaderDelegate;
import 'package:recipe_app/presentation/home/logic/ai_calorie_cubit/ai_calorie_cubit.dart';
import 'package:recipe_app/presentation/home/logic/ai_calorie_cubit/ai_calorie_state.dart';
import 'package:recipe_app/presentation/home/widgets/ai_chat_fab.dart' show AiChatFab;
import 'package:recipe_app/presentation/home/widgets/suggestion_dialog.dart' show showSuggestionDialog;
import 'package:recipe_app/presentation/home/widgets/ai_calorie_helper.dart' show handleAiCalorieState;
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController _scrollController;
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    context.read<UserCubit>().getMe();
  }

  Future<void> _checkDailySuggestion() async {
    final prefs = await SharedPreferences.getInstance();
    final todayStr = DateTime.now().toString().split(' ')[0];
    if (prefs.getString('last_suggestion_shown_date') != todayStr) {
      if (mounted) {
        context.read<RecipeCubit>().getRecipeSuggestion();
        await prefs.setString('last_suggestion_shown_date', todayStr);
      }
    }
  }

  void _scrollListener() {
    final show = _scrollController.offset > 80;
    if (show != _showFab) {
      setState(() => _showFab = show);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserCubit, UserState>(
          listener: (context, state) {
            if (state is GetMeSuccess) {
              if (!state.user.isOnboarded) {
                Navigator.pushReplacementNamed(context, 'onboarding');
              } else {
                _checkDailySuggestion();
              }
            }
          },
        ),
        BlocListener<RecipeCubit, RecipeState>(
          listener: (context, state) {
            if (state is RecipeSuggestionSuccess) {
              showSuggestionDialog(context, state.recipeModel);
            } else if (state is RecipeSuggestionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
        ),
        BlocListener<AiCalorieCubit, AiCalorieState>(
          listener: handleAiCalorieState,
        ),
      ],
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, builder) => [
            SliverPersistentHeader(
              pinned: true,
              delegate: SearchAndAiHeaderDelegate(
                safeAreaTop: MediaQuery.of(context).padding.top,
                searchWidget: const SearchFilter(),
              ),
            ),
          ],
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: context.setHeight(10)),
              TagList(),
              RecipeList(),
              SizedBox(height: context.setHeight(100)),
            ],
          ),
        ),
        floatingActionButton: AiChatFab(show: _showFab),
      ),
    );
  }
}
