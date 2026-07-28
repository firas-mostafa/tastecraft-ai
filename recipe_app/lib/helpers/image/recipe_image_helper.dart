class RecipeImageHelper {
  static const List<String> _fallbacks = [
    "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&auto=format&fit=crop", // Salad
    "https://images.unsplash.com/photo-1546549032-9571cd6b27df?w=600&auto=format&fit=crop", // Pasta
    "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&auto=format&fit=crop", // Pizza
    "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop", // Burger
    "https://images.unsplash.com/photo-1547592165-e1d17fed6006?w=600&auto=format&fit=crop", // Soup
    "https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=600&auto=format&fit=crop", // Chicken
    "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop", // Dessert
    "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=600&auto=format&fit=crop", // Breakfast
  ];

  static String getFallbackImage(int recipeId, String recipeTitle) {
    final title = recipeTitle.toLowerCase();
    
    // Fish & Seafood
    if (title.contains("fish") || 
        title.contains("tilapia") || 
        title.contains("salmon") || 
        title.contains("seafood") || 
        title.contains("shrimp") ||
        title.contains("tuna")) {
      return "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=600&auto=format&fit=crop";
    }
    // Chili, Soup & Stews
    if (title.contains("chili") || 
        title.contains("soup") || 
        title.contains("stew") || 
        title.contains("curry") ||
        title.contains("broth")) {
      return "https://images.unsplash.com/photo-1547592165-e1d17fed6006?w=600&auto=format&fit=crop";
    }
    // Salads & Veggies
    if (title.contains("salad") || 
        title.contains("greens") || 
        title.contains("vegetable") || 
        title.contains("veggie") || 
        title.contains("vegetarian") ||
        title.contains("broccoli") ||
        title.contains("spinach")) {
      return "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&auto=format&fit=crop";
    }
    // Pasta & Noodles
    if (title.contains("pasta") || 
        title.contains("spaghetti") || 
        title.contains("noodle") || 
        title.contains("lasagna") || 
        title.contains("macaroni") ||
        title.contains("ramen")) {
      return "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&auto=format&fit=crop";
    }
    // Pizza & Flatbreads
    if (title.contains("pizza") || 
        title.contains("bread") || 
        title.contains("toast") ||
        title.contains("flatbread")) {
      return "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&auto=format&fit=crop";
    }
    // Burgers & Sandwiches
    if (title.contains("burger") || 
        title.contains("sandwich") || 
        title.contains("taco") || 
        title.contains("wrap") || 
        title.contains("shawarma")) {
      return "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop";
    }
    // Desserts & Sweets
    if (title.contains("cake") || 
        title.contains("dessert") || 
        title.contains("sweet") || 
        title.contains("cookie") || 
        title.contains("chocolate") || 
        title.contains("ice cream") || 
        title.contains("muffin") || 
        title.contains("donut") ||
        title.contains("pie")) {
      return "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop";
    }
    // Chicken & Poultry
    if (title.contains("chicken") || 
        title.contains("poultry") || 
        title.contains("wings") || 
        title.contains("turkey") ||
        title.contains("duck")) {
      return "https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=600&auto=format&fit=crop";
    }
    // Beef & Meats
    if (title.contains("beef") || 
        title.contains("meat") || 
        title.contains("steak") || 
        title.contains("lamb") || 
        title.contains("kebab") || 
        title.contains("meatball") ||
        title.contains("pork")) {
      return "https://images.unsplash.com/photo-1544025162-d76694265947?w=600&auto=format&fit=crop";
    }
    // Breakfast
    if (title.contains("breakfast") || 
        title.contains("egg") || 
        title.contains("pancake") || 
        title.contains("waffle") || 
        title.contains("oat") ||
        title.contains("cereal")) {
      return "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=600&auto=format&fit=crop";
    }
    
    // Hash fallback to distribute other titles evenly
    final int index = recipeId.abs() % _fallbacks.length;
    return _fallbacks[index];
  }
}
