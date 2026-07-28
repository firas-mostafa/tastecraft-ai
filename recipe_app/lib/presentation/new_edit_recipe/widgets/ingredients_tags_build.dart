import 'package:flutter/material.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;
import 'package:recipe_app/logic/recipe_cubit/recipe_cubit.dart'
    show RecipeCubit;

class IngredientsTagsList extends StatelessWidget {
  final RecipeCubit cubit;
  final List<String> tags;
  final List<String> removeList;

  const IngredientsTagsList({
    super.key,
    required this.cubit,
    required this.tags,

    required this.removeList,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.setWidth(500),
      height: context.setMineSize(40),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(context.setMineSize(4)),
            height: context.setHeight(15),
            decoration: BoxDecoration(
              color: context.colorScheme.secondary,
              borderRadius: BorderRadius.circular(context.setMineSize(25)),
            ),
            child: Padding(
              padding: EdgeInsets.all(context.setMineSize(2)),
              child: Row(
                children: [
                  SizedBox(width: context.setMineSize(5)),

                  Text(
                    tags[index],
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: context.colorScheme.onSecondary,
                    ),
                  ),
                  SizedBox(width: context.setMineSize(10)),
                  InkWell(
                    onTap: () {
                      cubit.removeTagsIngredients(index, removeList);
                    },
                    child: CircleAvatar(
                      backgroundColor: context.colorScheme.onSecondary,
                      radius: context.setMineSize(15),
                      child: Icon(
                        Icons.close_rounded,
                        color: context.colorScheme.secondary,
                        size: context.setMineSize(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
