class EndPoint {
  // static String baseUrl = "https://n8xsgbkx-8000.euw.devtunnels.ms/"; // use Forward a Port method
  static String baseUrl = "http://10.0.2.2:8000/";

  static String api = "api/";
  static String recipe = "${api}recipe/";
  static String user = "${api}user/";
  static String ingredients = "${recipe}ingredients/";
  static String tags = "${recipe}tags/";
  static String uploadUserImage = "${user}user-upload-image/";
  static String me = "${user}me/";
  static String createUser = "${user}create/";
  static String recipes = "${recipe}recipes/";
  static String token = "${user}token/";
  static String recipeByID(int id) => "$recipes$id/";
  static String ingredientsByID(int id) => "$ingredients$id/";
  static String tagsByID(int id) => "$tags$id/";
  static String uploadRecipeImage(int id) => "${recipeByID(id)}upload-image/";
  static String mealPlan = "${recipe}meal-plan/";
  static String generateMealPlan = "${mealPlan}generate/";
  static String completeRecipeAi(int id) => "${recipeByID(id)}complete-ai/";
  static String analyzeCalories = "${recipe}analyze-calories/";
  static String suggestRecipe = "${recipe}recipes/suggest/";

  static String chat = "${api}chat/";
  static String conversations = "${chat}conversations/";
  static String conversationByID(int id) => "$conversations$id/";
  static String mealPlanAiNotes = "${mealPlan}ai-notes/";
}

class ApiKey {
  static String authorization = "Authorization";
  static String user = "user";
  static String recipe = "recipe";
  static String status = "status";
  static String email = "email";
  static String password = "password";
  static String token = "token";
  static String nonFieldErrors = "non_field_errors";
  static String message = "message";
  static String id = "id";
  static String name = "name";
  static String confirmPassword = "confirmPassword";
  static String image = "image";
  static String title = "title";
  static String timeMinutes = "time_minutes";
  static String price = "price";
  static String link = "link";
  static String tags = "tags";
  static String ingredients = "ingredients";
  static String description = "description";
  static String detail = "detail";
  static String heightCm = "height_cm";
  static String weightKg = "weight_kg";
  static String allergies = "allergies";
  static String isOnboarded = "is_onboarded";
  static String age = "age";
  static String diseases = "diseases";
  static String calories = "calories";
  static String isLiked = "is_liked";
  static String userNote = "user_note";
}
