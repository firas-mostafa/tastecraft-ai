import urllib.request
import urllib.parse
from channels.db import database_sync_to_async
from pydantic import BaseModel, Field
from core.models import Recipe, Tag, Ingredient
import asyncio

class RecipeToolInput(BaseModel):
    title: str = Field(description="Title of the recipe")
    time_minutes: int = Field(description="Preparation time in minutes")
    price: float = Field(description="Estimated cost")
    description: str = Field(description="Step-by-step cooking instructions and detailed description for the recipe")
    ingredients: list[str] = Field(description="List of ingredients")
    tags: list[str] = Field(description="List of tags like 'Breakfast' or 'Healthy'")
    youtube_link: str = Field(description="A YouTube search link or tutorial link for the recipe")
    image_prompt: str = Field(description="A highly detailed prompt in English to generate a beautiful image of this recipe")

@database_sync_to_async
def save_recipe_db(user, title, time_minutes, price, description, ingredients, tags, youtube_link, image_data):
    from django.core.files.base import ContentFile
    recipe = Recipe.objects.create(
        user=user,
        title=title,
        time_minutes=time_minutes,
        price=price,
        description=description,
        link=youtube_link,
    )
    if image_data:
        recipe.image.save("ai_recipe.jpg", ContentFile(image_data), save=True)

    for tag_name in tags:
        tag, _ = Tag.objects.get_or_create(user=user, name=tag_name)
        recipe.tags.add(tag)

    for ing_name in ingredients:
        ing, _ = Ingredient.objects.get_or_create(user=user, name=ing_name)
        recipe.ingredients.add(ing)

    return recipe

async def handle_recipe_saving(user, title: str, time_minutes: int, price: float, description: str, ingredients: list[str], tags: list[str], youtube_link: str, image_prompt: str) -> str:
    if not user or not user.is_authenticated:
        return "Failed to save: User not authenticated."
        
    image_data = None
    image_error_msg = ""
    try:
        encoded_prompt = urllib.parse.quote(image_prompt)
        image_url = f"https://image.pollinations.ai/prompt/{encoded_prompt}?width=800&height=800&nologo=true"
        
        loop = asyncio.get_event_loop()
        req = urllib.request.Request(image_url, headers={'User-Agent': 'Mozilla/5.0'})
        
        response = await loop.run_in_executor(None, urllib.request.urlopen, req)
        image_data = response.read()
    except Exception as img_err:
        image_error_msg = f" (Note: Could not generate AI image due to: {str(img_err)})"

    try:
        await save_recipe_db(user, title, time_minutes, price, description, ingredients, tags, youtube_link, image_data)
        return f"Recipe '{title}' saved successfully!{image_error_msg}"
    except Exception as e:
        return f"Failed to save recipe: {str(e)}"
