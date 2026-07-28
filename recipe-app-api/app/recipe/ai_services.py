import os
import json
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.messages import HumanMessage
from core.models import Ingredient, Recipe, Tag

def get_llm():
    api_key = os.environ.get("GEMINI_API_KEY") or os.environ.get("GOOGLE_API_KEY")
    return ChatGoogleGenerativeAI(model="gemini-2.5-flash", google_api_key=api_key)



def clean_json_response(content: str) -> dict:
    content = content.strip()
    
    # Try finding markdown code block
    if '```json' in content:
        try:
            start = content.index('```json') + 7
            end = content.index('```', start)
            return json.loads(content[start:end].strip())
        except ValueError:
            pass
    elif '```' in content:
        try:
            start = content.index('```') + 3
            end = content.index('```', start)
            return json.loads(content[start:end].strip())
        except ValueError:
            pass
            
    # Try finding the first '{' or '[' and last '}' or ']'
    try:
        start_obj = content.find('{')
        start_arr = content.find('[')
        
        # Determine the start boundary
        if start_obj != -1 and start_arr != -1:
            start = min(start_obj, start_arr)
        else:
            start = start_obj if start_obj != -1 else start_arr
            
        if start != -1:
            end_obj = content.rfind('}')
            end_arr = content.rfind(']')
            end = max(end_obj, end_arr) + 1
            if end > start:
                return json.loads(content[start:end])
    except Exception:
        pass
        
    return json.loads(content)

def complete_recipe_with_ai(recipe, user):
    prompt = f"""You are an expert chef. Complete the following recipe details for: {recipe.title}.
Current description: {recipe.description}
Please generate the full description, ingredients list (with amounts), instructions, realistic cooking time in minutes, estimated price in dollars, and estimated calories.
Return the response STRICTLY as a JSON object with this exact format:
{{
  "description": "Full mouth-watering description here",
  "time_minutes": 45,
  "price": 12.50,
  "calories": 350,
  "ingredients": [
    {{"name": "Ingredient 1"}},
    {{"name": "Ingredient 2"}}
  ],
  "instructions": "Step 1: do this\\nStep 2: do that"
}}
Do not include any markdown formatting or extra text outside the JSON."""

    llm = get_llm()
    response = llm.invoke(prompt)
    data = clean_json_response(response.content)

    description = data.get('description', recipe.description)
    instructions = data.get('instructions', '')
    if instructions:
        description += f"\n\nInstructions:\n{instructions}"
    recipe.description = description
    recipe.time_minutes = data.get('time_minutes', recipe.time_minutes)
    recipe.price = data.get('price', recipe.price)
    recipe.calories = data.get('calories', None)
    recipe.save()

    for ing_data in data.get('ingredients', []):
        ing_name = ing_data.get('name')
        if ing_name:
            ing, _ = Ingredient.objects.get_or_create(user=user, name=ing_name)
            recipe.ingredients.add(ing)
    return recipe

def generate_meal_plan_ai(user, custom_prompt="", google_fit_data=None):
    health_profile = getattr(user, 'healthprofile', None)
    if health_profile and health_profile.height_cm and health_profile.weight_kg:
        height_m = health_profile.height_cm / 100
        bmi = health_profile.weight_kg / (height_m * height_m)
    else:
        bmi = 22.0
    
    age_str = str(health_profile.age) if health_profile and health_profile.age else 'adult'
    allergies_list = [a.name for a in health_profile.allergies.all()] if health_profile else []
    diseases_list = [d.name for d in health_profile.diseases.all()] if health_profile else []
    allergies_str = ", ".join(allergies_list) if allergies_list else "None"
    diseases_str = ", ".join(diseases_list) if diseases_list else "None"
    
    fit_str = ""
    if google_fit_data:
        steps = google_fit_data.get('steps', 0)
        calories = google_fit_data.get('calories', 0)
        fit_str = f"The user logged Google Fit activity today: {steps} steps and {calories} active calories burned. Take this into consideration when setting calorie targets."
 
    prompt = f"""Generate a 7-day healthy meal plan for a {age_str} year old person with a BMI of {bmi:.1f}. Their allergies/preferences are: {allergies_str}. Their chronic diseases or health conditions are: {diseases_str}. 
{fit_str}
{f'The user specifically requested: {custom_prompt}' if custom_prompt else ''}
Return the response STRICTLY as a JSON object with this exact format:
{{
  "days": [
    {{
      "day": "Monday",
      "breakfast": [{{"title": "Recipe 1", "description": "Brief description", "calories": 300}}, {{"title": "Recipe 2", "description": "Brief description", "calories": 350}}],
      "lunch": [{{"title": "Recipe 1", "description": "Brief description", "calories": 500}}, {{"title": "Recipe 2", "description": "Brief description", "calories": 550}}],
      "dessert": [{{"title": "Recipe 1", "description": "Brief description", "calories": 200}}, {{"title": "Recipe 2", "description": "Brief description", "calories": 250}}],
      "dinner": [{{"title": "Recipe 1", "description": "Brief description", "calories": 400}}, {{"title": "Recipe 2", "description": "Brief description", "calories": 450}}]
    }}
  ]
}}
Ensure exactly 7 days, and exactly 2 options for each meal time. Do not include any markdown formatting or extra text outside the JSON."""

    llm = get_llm()
    response = llm.invoke(prompt)
    plan_data = clean_json_response(response.content)

    from django.db import transaction
    with transaction.atomic():
        for day in plan_data.get('days', []):
            for meal_type in ['breakfast', 'lunch', 'dessert', 'dinner']:
                options = day.get(meal_type, [])
                for idx, option in enumerate(options):
                    recipe = Recipe.objects.create(
                        user=user,
                        title=option.get('title', 'Generated Recipe'),
                        description=option.get('description', ''),
                        time_minutes=30, 
                        price=15.00,
                        calories=option.get('calories')
                    )
                    tag_name = meal_type.capitalize()
                    tag, _ = Tag.objects.get_or_create(user=user, name=tag_name)
                    recipe.tags.add(tag)
                    
                    options[idx]['id'] = recipe.id
                    options[idx]['time_minutes'] = recipe.time_minutes
                    options[idx]['price'] = float(recipe.price)
                    options[idx]['calories'] = recipe.calories
    return plan_data

def suggest_recipe_ai(user):
    health_profile = getattr(user, 'healthprofile', None)
    if health_profile and health_profile.height_cm and health_profile.weight_kg:
        height_m = health_profile.height_cm / 100
        bmi = health_profile.weight_kg / (height_m * height_m)
    else:
        bmi = 22.0
    age_str = str(health_profile.age) if health_profile and health_profile.age else 'adult'
    allergies_str = ", ".join([a.name for a in health_profile.allergies.all()]) if health_profile and health_profile.allergies.exists() else "None"
    diseases_str = ", ".join([d.name for d in health_profile.diseases.all()]) if health_profile and health_profile.diseases.exists() else "None"

    prompt = f"""You are an expert chef. Recommend a healthy, customized suggested recipe for today to try. 
The person is {age_str} years old, has a BMI of {bmi:.1f}. Their allergies/preferences are: {allergies_str}. Their chronic diseases or conditions are: {diseases_str}.
Return the response STRICTLY as a JSON object with this exact format:
{{
  "title": "A tasty recipe title",
  "description": "Short description of the recipe",
  "time_minutes": 35,
  "price": 10.00,
  "calories": 420,
  "tags": ["Dinner", "Healthy"],
  "ingredients": [
    {{"name": "Ingredient 1"}},
    {{"name": "Ingredient 2"}}
  ],
  "instructions": "Step 1: do this\\nStep 2: do that"
}}
Do not include any markdown formatting or extra text outside the JSON."""

    llm = get_llm()
    response = llm.invoke(prompt)
    data = clean_json_response(response.content)

    recipe = Recipe.objects.create(
        user=user,
        title=data.get('title', 'Suggested Recipe'),
        description=data.get('description', '') + f"\n\nInstructions:\n{data.get('instructions', '')}",
        time_minutes=data.get('time_minutes', 30),
        price=data.get('price', 10.00),
        calories=data.get('calories')
    )

    for tag_name in data.get('tags', []):
        tag, _ = Tag.objects.get_or_create(user=user, name=tag_name)
        recipe.tags.add(tag)

    for ing_data in data.get('ingredients', []):
        ing_name = ing_data.get('name')
        if ing_name:
            ing, _ = Ingredient.objects.get_or_create(user=user, name=ing_name)
            recipe.ingredients.add(ing)

    return recipe

def generate_meal_plan_notes_ai(user, plan_data, language='ar'):
    health_profile = getattr(user, 'healthprofile', None)
    allergies = ", ".join([a.name for a in health_profile.allergies.all()]) if health_profile and health_profile.allergies.exists() else "None"
    diseases = ", ".join([d.name for d in health_profile.diseases.all()]) if health_profile and health_profile.diseases.exists() else "None"
    
    prompt = f"""You are a certified dietitian and health coach. The user has the following health profile:
- Allergies / Preferences: {allergies}
- Chronic diseases / Health conditions: {diseases}
Here is their current 7-day meal plan:
{json.dumps(plan_data, indent=2)}

Please write exactly 5 concise, actionable dietary/health tips or feedback notes regarding this meal plan. Custom fit these tips to their chronic diseases (like Diabetes or Hypertension) and allergies.
Write the response in {'Arabic' if language == 'ar' else 'English'} language.
Return ONLY the tips as a markdown bulleted list. Do not write any intro or outro."""

    llm = get_llm()
    response = llm.invoke(prompt)
    return response.content.strip()

def analyze_calories_ai(base64_image: str, language: str = 'en') -> str:
    # Strip base64 data URL prefix if present
    if ',' in base64_image and base64_image.startswith('data:'):
        base64_image = base64_image.split(',', 1)[1]

    prompt = f"Analyze this image of a meal. Identify the main ingredients, estimate the portion size, and calculate the approximate calories. Return a beautiful, concise summary. Please provide the response in {'Arabic' if language == 'ar' else 'English'}."
    
    llm = get_llm()
    message = HumanMessage(
        content=[
            {"type": "text", "text": prompt},
            {"type": "image_url", "image_url": {"url": f"data:image/jpeg;base64,{base64_image}"}}
        ]
    )
    response = llm.invoke([message])
    return response.content.strip()
