import 'package:flutter/material.dart'
    show RouteSettings, Route, MaterialPageRoute;
import 'package:recipe_app/data/models/recipe_models/recipe_model.dart'
    show RecipeModel;
import 'package:recipe_app/presentation/profile/screens/edit_profile.dart'
    show EditProfile;
import 'package:recipe_app/presentation/profile/screens/terms_of_use.dart'
    show TermsOfUse;
import 'package:recipe_app/presentation/auth/screens/create_account.dart'
    show CreateAccount;
import 'package:recipe_app/presentation/auth/screens/login.dart' show Login;
import 'package:recipe_app/presentation/auth/screens/onboarding_screen.dart'
    show OnboardingScreen;
import 'package:recipe_app/presentation/main/screens/main_screen.dart'
    show MainScreen;
import 'package:recipe_app/presentation/recipe/screens/recipe_detail.dart'
    show RecipeDetail;
import 'package:recipe_app/presentation/ai_chat/screens/ai_chat_screen.dart'
    show AiChatScreen;
import 'package:recipe_app/presentation/new_edit_recipe/screens/recipe_form_screen.dart'
    show RecipeFormScreen;

class AppRouter {
  static const String recipeDetail = 'recipe_detail';
  static const String editRecipe = 'edit_recipe';

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainScreen());
      case 'login':
        return MaterialPageRoute(builder: (_) => Login());
      case 'onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case 'create_account':
        return MaterialPageRoute(builder: (_) => CreateAccount());
      case 'terms_of_use':
        return MaterialPageRoute(builder: (_) => TermsOfUse());
      case 'edit_profile':
        return MaterialPageRoute(builder: (_) => EditProfile());
      case 'ai_chat':
        return MaterialPageRoute(builder: (_) => AiChatScreen());
      case 'new_recipe':
        return MaterialPageRoute(builder: (_) => const RecipeFormScreen());
      case recipeDetail:
        final recipe = routeSettings.arguments as RecipeModel;
        return MaterialPageRoute(
          builder: (_) => RecipeDetail(recipe: recipe),
          settings: routeSettings,
        );
      case editRecipe:
        final recipe = routeSettings.arguments as RecipeModel;
        return MaterialPageRoute(
          builder: (_) => RecipeFormScreen(recipeModel: recipe),
          settings: routeSettings,
        );
      default:
        return MaterialPageRoute(builder: (_) => MainScreen());
    }
  }
}
