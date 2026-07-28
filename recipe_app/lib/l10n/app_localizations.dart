import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TasteCraft AI'**
  String get appTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search about your fav recipe'**
  String get searchHint;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @mealPlanTab.
  ///
  /// In en, this message translates to:
  /// **'Meal Plan'**
  String get mealPlanTab;

  /// No description provided for @newRecipeTab.
  ///
  /// In en, this message translates to:
  /// **'New Recipe'**
  String get newRecipeTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @recipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Recipe title *'**
  String get recipeTitle;

  /// No description provided for @recipeTime.
  ///
  /// In en, this message translates to:
  /// **'Recipe time *'**
  String get recipeTime;

  /// No description provided for @recipeCost.
  ///
  /// In en, this message translates to:
  /// **'Recipe expected cost *'**
  String get recipeCost;

  /// No description provided for @addReference.
  ///
  /// In en, this message translates to:
  /// **'Add a reference'**
  String get addReference;

  /// No description provided for @recipeIngredients.
  ///
  /// In en, this message translates to:
  /// **'Recipe ingredients'**
  String get recipeIngredients;

  /// No description provided for @addIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add Ingredient'**
  String get addIngredient;

  /// No description provided for @recipeTags.
  ///
  /// In en, this message translates to:
  /// **'Recipe Tags'**
  String get recipeTags;

  /// No description provided for @addTag.
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get addTag;

  /// No description provided for @recipeDescription.
  ///
  /// In en, this message translates to:
  /// **'Recipe description'**
  String get recipeDescription;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @ingredientsSection.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredientsSection;

  /// No description provided for @descriptionSection.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionSection;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description provided.'**
  String get noDescription;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'add image'**
  String get addImage;

  /// No description provided for @editRecipe.
  ///
  /// In en, this message translates to:
  /// **'Edit Recipe'**
  String get editRecipe;

  /// No description provided for @successRecipeCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Recipe Success'**
  String get successRecipeCreate;

  /// No description provided for @successRecipeUpdate.
  ///
  /// In en, this message translates to:
  /// **'Recipe Updated Successfully'**
  String get successRecipeUpdate;

  /// No description provided for @noRecipesHere.
  ///
  /// In en, this message translates to:
  /// **'No recipes found here'**
  String get noRecipesHere;

  /// No description provided for @aiChefAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Chef Assistant'**
  String get aiChefAssistant;

  /// No description provided for @aiChefDescription.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about recipes!'**
  String get aiChefDescription;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @reportBug.
  ///
  /// In en, this message translates to:
  /// **'Report a bug'**
  String get reportBug;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUse;

  /// No description provided for @editAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get editAccount;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountTitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @deleteRecipe.
  ///
  /// In en, this message translates to:
  /// **'Delete Recipe'**
  String get deleteRecipe;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get areYouSureLogout;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @tagAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tagAll;

  /// No description provided for @tagBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get tagBreakfast;

  /// No description provided for @tagLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get tagLunch;

  /// No description provided for @tagDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get tagDinner;

  /// No description provided for @tagSandwich.
  ///
  /// In en, this message translates to:
  /// **'Sandwich'**
  String get tagSandwich;

  /// No description provided for @tagDessert.
  ///
  /// In en, this message translates to:
  /// **'Dessert'**
  String get tagDessert;

  /// No description provided for @advancedFilters.
  ///
  /// In en, this message translates to:
  /// **'Advanced Filters'**
  String get advancedFilters;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @healthProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Profile'**
  String get healthProfileTitle;

  /// No description provided for @healthProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s personalize your experience!'**
  String get healthProfileSubtitle;

  /// No description provided for @healthProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'We need this info to generate your weekly meal plans and calculate your BMI.'**
  String get healthProfileDesc;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightLabel;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightLabel;

  /// No description provided for @calculatedBmi.
  ///
  /// In en, this message translates to:
  /// **'CALCULATED BMI'**
  String get calculatedBmi;

  /// No description provided for @enterHeightWeightBmi.
  ///
  /// In en, this message translates to:
  /// **'Enter your height and weight to calculate your BMI.'**
  String get enterHeightWeightBmi;

  /// No description provided for @bmiUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get bmiUnderweight;

  /// No description provided for @bmiNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get bmiNormal;

  /// No description provided for @bmiOverweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get bmiOverweight;

  /// No description provided for @bmiObese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get bmiObese;

  /// No description provided for @bmiUnderweightDesc.
  ///
  /// In en, this message translates to:
  /// **'Your body mass index is below the healthy range.'**
  String get bmiUnderweightDesc;

  /// No description provided for @bmiNormalDesc.
  ///
  /// In en, this message translates to:
  /// **'Based on your height and weight, your body mass index is within the healthy range.'**
  String get bmiNormalDesc;

  /// No description provided for @bmiOverweightDesc.
  ///
  /// In en, this message translates to:
  /// **'Your body mass index is above the healthy range.'**
  String get bmiOverweightDesc;

  /// No description provided for @bmiObeseDesc.
  ///
  /// In en, this message translates to:
  /// **'Your body mass index is significantly above the healthy range.'**
  String get bmiObeseDesc;

  /// No description provided for @chronicDiseases.
  ///
  /// In en, this message translates to:
  /// **'Chronic Diseases'**
  String get chronicDiseases;

  /// No description provided for @chronicDiseasesDesc.
  ///
  /// In en, this message translates to:
  /// **'Select any diseases that might affect your meal plan.'**
  String get chronicDiseasesDesc;

  /// No description provided for @diabetes.
  ///
  /// In en, this message translates to:
  /// **'Diabetes'**
  String get diabetes;

  /// No description provided for @hypertension.
  ///
  /// In en, this message translates to:
  /// **'Hypertension'**
  String get hypertension;

  /// No description provided for @asthma.
  ///
  /// In en, this message translates to:
  /// **'Asthma'**
  String get asthma;

  /// No description provided for @noneLabel.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noneLabel;

  /// No description provided for @foodAllergies.
  ///
  /// In en, this message translates to:
  /// **'Food Allergies & Preferences'**
  String get foodAllergies;

  /// No description provided for @foodAllergiesDesc.
  ///
  /// In en, this message translates to:
  /// **'Select common ingredients that cause allergies for you.'**
  String get foodAllergiesDesc;

  /// No description provided for @eggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get eggs;

  /// No description provided for @chocolate.
  ///
  /// In en, this message translates to:
  /// **'Chocolate'**
  String get chocolate;

  /// No description provided for @peanuts.
  ///
  /// In en, this message translates to:
  /// **'Peanuts'**
  String get peanuts;

  /// No description provided for @glutenFree.
  ///
  /// In en, this message translates to:
  /// **'Gluten-Free'**
  String get glutenFree;

  /// No description provided for @aiInstructions.
  ///
  /// In en, this message translates to:
  /// **'Additional AI Instructions'**
  String get aiInstructions;

  /// No description provided for @aiInstructionsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. I prefer high protein meals, or no spicy food.'**
  String get aiInstructionsHint;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @completeOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Complete Onboarding'**
  String get completeOnboarding;

  /// No description provided for @addDisease.
  ///
  /// In en, this message translates to:
  /// **'Add Disease'**
  String get addDisease;

  /// No description provided for @addAllergy.
  ///
  /// In en, this message translates to:
  /// **'Add Allergy'**
  String get addAllergy;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enterName;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @invalidField.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalidField;

  /// No description provided for @mealPlanEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Talk to AI to design a weekly meal plan specifically for you'**
  String get mealPlanEmptyTitle;

  /// No description provided for @mealPlanPromptHint.
  ///
  /// In en, this message translates to:
  /// **'Add special instructions for AI (optional)'**
  String get mealPlanPromptHint;

  /// No description provided for @generateMyPlan.
  ///
  /// In en, this message translates to:
  /// **'Generate my plan now'**
  String get generateMyPlan;

  /// No description provided for @mealPlanChangePromptHint.
  ///
  /// In en, this message translates to:
  /// **'Add special instructions (e.g. I want a light dinner)'**
  String get mealPlanChangePromptHint;

  /// No description provided for @changeCustomPlan.
  ///
  /// In en, this message translates to:
  /// **'Change custom plan'**
  String get changeCustomPlan;

  /// No description provided for @weeklyMealPlan.
  ///
  /// In en, this message translates to:
  /// **'Weekly Meal Plan'**
  String get weeklyMealPlan;

  /// No description provided for @retryBtn.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryBtn;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get errorPrefix;

  /// No description provided for @tagSalad.
  ///
  /// In en, this message translates to:
  /// **'Salads'**
  String get tagSalad;

  /// No description provided for @tagSpicy.
  ///
  /// In en, this message translates to:
  /// **'Spicy Meals'**
  String get tagSpicy;

  /// No description provided for @tagDrink.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get tagDrink;

  /// No description provided for @completeRecipe.
  ///
  /// In en, this message translates to:
  /// **'Complete Details'**
  String get completeRecipe;

  /// No description provided for @aiChatOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get aiChatOnline;

  /// No description provided for @aiChatConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get aiChatConnecting;

  /// No description provided for @aiChatOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get aiChatOffline;

  /// No description provided for @aiChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your Personal Recipe AI'**
  String get aiChatSubtitle;

  /// No description provided for @aiChatDescription.
  ///
  /// In en, this message translates to:
  /// **'Ask me any cooking question, request recipe lists, or ask for ingredient substitutes!'**
  String get aiChatDescription;

  /// No description provided for @aiChatTryAsking.
  ///
  /// In en, this message translates to:
  /// **'Try asking:'**
  String get aiChatTryAsking;

  /// No description provided for @aiChatSuggestion1.
  ///
  /// In en, this message translates to:
  /// **'Suggest a quick dinner recipe 🍽️'**
  String get aiChatSuggestion1;

  /// No description provided for @aiChatSuggestion2.
  ///
  /// In en, this message translates to:
  /// **'How do I make chocolate chip cookies? 🍪'**
  String get aiChatSuggestion2;

  /// No description provided for @aiChatSuggestion3.
  ///
  /// In en, this message translates to:
  /// **'Give me a healthy breakfast idea 🍳'**
  String get aiChatSuggestion3;

  /// No description provided for @aiChatSuggestion4.
  ///
  /// In en, this message translates to:
  /// **'What can I cook with tomatoes and cheese? 🍅🧀'**
  String get aiChatSuggestion4;

  /// No description provided for @aiChatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask the Chef...'**
  String get aiChatInputHint;

  /// No description provided for @aiChatPhotoGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo Library'**
  String get aiChatPhotoGallery;

  /// No description provided for @aiChatCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get aiChatCamera;

  /// No description provided for @aiChatMicPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission denied'**
  String get aiChatMicPermissionDenied;

  /// No description provided for @aiCalorieCalculator.
  ///
  /// In en, this message translates to:
  /// **'Calorie Calculator'**
  String get aiCalorieCalculator;

  /// No description provided for @aiCalorieTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Calorie Estimate'**
  String get aiCalorieTitle;

  /// No description provided for @aiCalorieResult.
  ///
  /// In en, this message translates to:
  /// **'Calorie Estimate'**
  String get aiCalorieResult;

  /// No description provided for @aiCalorieLoading.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your meal...'**
  String get aiCalorieLoading;

  /// No description provided for @viewRecipe.
  ///
  /// In en, this message translates to:
  /// **'View Recipe'**
  String get viewRecipe;

  /// No description provided for @minuteShort.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get minuteShort;

  /// No description provided for @caloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get caloriesLabel;

  /// No description provided for @kcal.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kcal;

  /// No description provided for @rateMealTitle.
  ///
  /// In en, this message translates to:
  /// **'How would you rate this meal?'**
  String get rateMealTitle;

  /// No description provided for @myNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'My Notes on the Meal'**
  String get myNotesLabel;

  /// No description provided for @saveNotes.
  ///
  /// In en, this message translates to:
  /// **'Save Note'**
  String get saveNotes;

  /// No description provided for @saveNotesSuccess.
  ///
  /// In en, this message translates to:
  /// **'Notes saved successfully'**
  String get saveNotesSuccess;

  /// No description provided for @likeLabel.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get likeLabel;

  /// No description provided for @dislikeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dislike'**
  String get dislikeLabel;

  /// No description provided for @suggestedRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested Recipe'**
  String get suggestedRecipeTitle;

  /// No description provided for @suggestedRecipeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily AI Suggestion'**
  String get suggestedRecipeDialogTitle;

  /// No description provided for @suggestedRecipeDialogDesc.
  ///
  /// In en, this message translates to:
  /// **'A healthy recipe recommended specifically for you today, based on your profile and preferences.'**
  String get suggestedRecipeDialogDesc;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export to PDF'**
  String get exportPdf;

  /// No description provided for @pdfGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF file...'**
  String get pdfGenerating;

  /// No description provided for @connectGoogleFit.
  ///
  /// In en, this message translates to:
  /// **'Connect Google Fit'**
  String get connectGoogleFit;

  /// No description provided for @googleFitConnected.
  ///
  /// In en, this message translates to:
  /// **'Successfully connected to Google Fit'**
  String get googleFitConnected;

  /// No description provided for @googleFitDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Google Fit'**
  String get googleFitDisconnected;

  /// No description provided for @googleFitPermissionsRequired.
  ///
  /// In en, this message translates to:
  /// **'The app requires access to Google Fit / Health Connect data to sync your activity with the AI Chef.'**
  String get googleFitPermissionsRequired;

  /// No description provided for @aiNotesPdfSection.
  ///
  /// In en, this message translates to:
  /// **'AI Chef Recommendations & Tips'**
  String get aiNotesPdfSection;

  /// No description provided for @addRecipe.
  ///
  /// In en, this message translates to:
  /// **'Add Recipe'**
  String get addRecipe;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection currently'**
  String get noInternet;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
