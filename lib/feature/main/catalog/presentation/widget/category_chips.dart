part of 'widgets.dart';

class CategoryChips extends StatelessWidget {
  final List<String> chips;
  final int selected;
  final ValueChanged<int> onSelect;

  const CategoryChips({
    super.key,
    required this.chips,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: BlocProvider(
        create: (context) => getIt<GetCatagoryCubit>(),
        child: BlocBuilder<GetCatagoryCubit, BaseState<List<GetCategoryModel>>>(
          builder: (context, state) {
            final categoriesWithAll = [
              GetCategoryModel(id: 0, name: 'الكل'),
              ...?state.data,
            ];
            return Row(
              children: List.generate(
                categoriesWithAll.length,
                (i) => GestureDetector(
                  onTap: () => onSelect(categoriesWithAll[i].id),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 1.5.w,
                      vertical: 2.h,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: categoriesWithAll[i].id == selected
                          ? AppColors.mainAppColor
                          : AppColors.bgSecondary,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: categoriesWithAll[i].id == selected
                            ? AppColors.mainAppColor
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      categoriesWithAll[i].name,
                      style: AppTextTheme.labelSmall.copyWith(
                        color: categoriesWithAll[i].id == selected
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: categoriesWithAll[i].id == selected
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
