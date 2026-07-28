import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocConsumer, BlocProvider, ReadContext;
import 'package:recipe_app/data/models/recipe_models/recipe_model.dart' show RecipeModel;
import 'package:recipe_app/presentation/new_edit_recipe/widgets/custom_tile_title.dart' show CustomTileTitle;
import 'package:recipe_app/helpers/responsive/device_utils.dart' show DeviceUtils;
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart' show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart' show ThemeHelperExtension;
import 'package:recipe_app/logic/recipe_cubit/recipe_cubit.dart';
import 'package:recipe_app/presentation/new_edit_recipe/logic/image_picker/image_picker_cubit.dart' show ImagePickerCubit;
import 'package:recipe_app/presentation/new_edit_recipe/widgets/ingredients_tags_build.dart' show IngredientsTagsList;
import 'package:recipe_app/presentation/new_edit_recipe/widgets/recipe_picture.dart' show RecipePicturePicker;
import 'package:recipe_app/presentation/widgets/custom_button.dart' show CustomButton;
import 'package:recipe_app/presentation/widgets/custom_dialog.dart' show CustomDialog;
import 'package:recipe_app/presentation/widgets/custom_text_field.dart' show CustomTextField;
import 'package:recipe_app/l10n/app_localizations.dart';

class RecipeFormScreen extends StatefulWidget {
  final RecipeModel? recipeModel;
  const RecipeFormScreen({super.key, this.recipeModel});

  @override
  State<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends State<RecipeFormScreen> {
  late ImagePickerCubit imagePickerCubit;
  bool get isEdit => widget.recipeModel != null;

  @override
  void initState() {
    super.initState();
    imagePickerCubit = ImagePickerCubit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isEdit) {
        // Prepopulate with partial data immediately to avoid blank screen
        context.read<RecipeCubit>().prepopulateEditData(widget.recipeModel!);
        // Fetch full recipe to get the missing fields (description, etc.)
        context.read<RecipeCubit>().getRecipeByID(widget.recipeModel!.id);
      }
    });
  }

  @override
  void dispose() {
    imagePickerCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? l10n.editRecipe : l10n.newRecipeTab),
        centerTitle: true,
      ),
      body: BlocConsumer<RecipeCubit, RecipeState>(
        listener: (consumerContext, state) {
          if (state is GetRecipeSuccess) {
            consumerContext.read<RecipeCubit>().prepopulateEditData(state.recipeModel);
          } else if (state is CreateRecipeSuccess || state is EditRecipeSuccess) {
            consumerContext.read<RecipeCubit>().getRecipesList();
            imagePickerCubit.clear();
            showDialog(
              context: consumerContext,
              builder: (context) => CustomDialog(
                icon: Icons.mood_rounded,
                backgroundColor: context.colorScheme.primaryContainer,
                text: isEdit ? l10n.successRecipeUpdate : l10n.successRecipeCreate,
                textColor: context.colorScheme.onPrimaryContainer,
              ),
            );
          } else if (state is CreateRecipeFailure || state is EditRecipeFailure) {
            final errorMsg = state is CreateRecipeFailure
                ? state.errorMessage
                : (state as EditRecipeFailure).errorMessage;
            showDialog(
              context: consumerContext,
              builder: (context) => CustomDialog(
                icon: Icons.sentiment_dissatisfied_rounded,
                backgroundColor: context.colorScheme.errorContainer,
                text: errorMsg,
                textColor: context.colorScheme.onErrorContainer,
              ),
            );
          } else if (state is UploadRecipePicFailure) {
            showDialog(
              context: consumerContext,
              builder: (context) => CustomDialog(
                icon: Icons.sentiment_dissatisfied_rounded,
                backgroundColor: context.colorScheme.errorContainer,
                text: "Image upload failed: ${state.errorMessage}",
                textColor: context.colorScheme.onErrorContainer,
              ),
            );
          }
        },
        builder: (consumerContext, state) {
          RecipeCubit cubit = consumerContext.read<RecipeCubit>();

          return SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(context.setMineSize(10)),
                child: SizedBox(
                  width: DeviceUtils.valueDecider(
                    context,
                    onMobile: context.setWidth(500),
                    onDesktop: context.setWidth(300),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocProvider(
                          create: (context) => imagePickerCubit,
                          child: RecipePicturePicker(
                            initialImageUrl: isEdit
                                ? (state is GetRecipeSuccess
                                    ? state.recipeModel.image
                                    : widget.recipeModel!.image)
                                : null,
                          ),
                        ),
                        CustomTileTitle(l10n.recipeTitle),
                        CustomTextField(
                          controller: cubit.recipeCreateTitle,
                          text: l10n.recipeTitle,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(consumerContext).requestFocus(cubit.recipeCreateTimeMinutesNode);
                          },
                          focusNode: cubit.recipeCreateTitleNode,
                        ),
                        CustomTileTitle(l10n.recipeTime),
                        CustomTextField(
                          controller: cubit.recipeCreateTimeMinutes,
                          text: l10n.minutes,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(consumerContext).requestFocus(cubit.recipeCreatepriceNode);
                          },
                          focusNode: cubit.recipeCreateTimeMinutesNode,
                        ),
                        CustomTileTitle(l10n.recipeCost),
                        CustomTextField(
                          controller: cubit.recipeCreateprice,
                          text: l10n.cost,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(consumerContext).requestFocus(cubit.recipeCreatelinkNode);
                          },
                          focusNode: cubit.recipeCreatepriceNode,
                        ),
                        CustomTileTitle(l10n.addReference),
                        CustomTextField(
                          controller: cubit.recipeCreatelink,
                          text: l10n.addReference,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(consumerContext).requestFocus(cubit.recipeCreateIngredientNode);
                          },
                          focusNode: cubit.recipeCreatelinkNode,
                        ),
                        CustomTileTitle(l10n.recipeIngredients),
                        IngredientsTagsList(
                          cubit: cubit,
                          tags: state is TagsAndIngredients
                              ? state.ingredients
                              : (isEdit ? cubit.ingredients : []),
                          removeList: cubit.ingredients,
                        ),
                        CustomTextField(
                          controller: cubit.recipeCreateIngredient,
                          text: l10n.addIngredient,
                          textInputAction: TextInputAction.none,
                          onFieldSubmitted: (_) {
                            cubit.addIngredient();
                          },
                          focusNode: cubit.recipeCreateIngredientNode,
                        ),
                        CustomTileTitle(l10n.recipeTags),
                        IngredientsTagsList(
                          cubit: cubit,
                          tags: state is TagsAndIngredients
                              ? state.tags
                              : (isEdit ? cubit.tags : []),
                          removeList: cubit.tags,
                        ),
                        CustomTextField(
                          controller: cubit.recipeCreateTag,
                          text: l10n.addTag,
                          textInputAction: TextInputAction.none,
                          onFieldSubmitted: (_) {
                            cubit.addTag();
                          },
                          focusNode: cubit.recipeCreateTagNode,
                        ),
                        CustomTileTitle(l10n.recipeDescription),
                        BlocProvider.value(
                          value: imagePickerCubit,
                          child: Builder(
                            builder: (buildContext) {
                              return CustomTextField(
                                controller: cubit.recipeCreatedescription,
                                text: l10n.recipeDescription,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) {
                                  _saveForm(buildContext, cubit);
                                },
                                focusNode: cubit.recipeCreatedescriptionNode,
                                minLines: 6,
                                maxLines: 7,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: context.setHeight(40)),
                        BlocProvider.value(
                          value: imagePickerCubit,
                          child: Builder(
                            builder: (buildContext) {
                              final isLoading = state is CreateRecipeLoading ||
                                  state is EditRecipeLoading ||
                                  state is UploadRecipePicLoading;
                              return isLoading
                                  ? const Center(child: CircularProgressIndicator())
                                  : CustomButton(
                                      onTap: () => _saveForm(buildContext, cubit),
                                      text: isEdit ? l10n.saveChanges : l10n.submit,
                                    );
                            },
                          ),
                        ),
                        SizedBox(height: context.setHeight(100)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveForm(BuildContext buildContext, RecipeCubit cubit) {
    final pickerState = buildContext.read<ImagePickerCubit>().state;
    if (isEdit) {
      cubit.patchRecipeByID(
        widget.recipeModel!.id,
        newImage: pickerState.image,
      );
    } else {
      cubit.recipeCreate(
        image: pickerState.image,
      );
    }
  }
}
