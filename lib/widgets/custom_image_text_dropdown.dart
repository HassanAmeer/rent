import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/apidata/categoryapi.dart';
import 'package:rent/constants/appColors.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/models/catgModel.dart';
import 'package:rent/widgets/casheimage.dart';

class CustomImageTextDropdown extends ConsumerStatefulWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;
  final String hintText;
  final bool enabled;

  const CustomImageTextDropdown({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
    this.hintText = 'Select a category',
    this.enabled = true,
  });

  @override
  ConsumerState<CustomImageTextDropdown> createState() =>
      _CustomImageTextDropdownState();
}

class _CustomImageTextDropdownState
    extends ConsumerState<CustomImageTextDropdown> {
  CategoryModel? _selectedCategoryModel;

  @override
  void initState() {
    super.initState();
    // Find the selected category model when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectedCategoryModel();
    });
  }

  @override
  void didUpdateWidget(CustomImageTextDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      _updateSelectedCategoryModel();
    }
  }

  void _updateSelectedCategoryModel() {
    final categoryApi = ref.read(categoryProvider);
    if (widget.selectedCategory != null && categoryApi.categories.isNotEmpty) {
      _selectedCategoryModel = categoryApi.getCategoryByName(
        widget.selectedCategory!,
      );
    } else {
      _selectedCategoryModel = null;
    }
    setState(() {});
  }

  void _showCategoryPicker() async {
    final categoryApi = ref.read(categoryProvider);

    // Load categories if not loaded
    if (!categoryApi.hasLoaded) {
      await ref
          .read(categoryProvider)
          .fetchCategoriesIfNeeded(loadingFor: "category");
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Select Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              // Loading state
              if (categoryApi.loadingFor == "category")
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading categories...'),
                      ],
                    ),
                  ),
                )
              else if (categoryApi.categories.isEmpty)
                const Expanded(
                  child: Center(child: Text('No categories available')),
                )
              else
                // Categories List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: categoryApi.categories.length,
                    itemBuilder: (context, index) {
                      final category = categoryApi.categories[index];
                      final isSelected =
                          widget.selectedCategory == category.name;

                      return InkWell(
                        onTap: () {
                          widget.onCategorySelected(category.name);
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.mainColor.withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.mainColor
                                  : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Category Image
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey[200]!,
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: category.fullImageUrl.isNotEmpty
                                      ? CacheImageWidget(
                                          url: category.fullImageUrl,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: AppColors.mainColor
                                              .withOpacity(0.1),
                                          child: Icon(
                                            _getCategoryIcon(category.name),
                                            color: AppColors.mainColor,
                                            size: 24,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Category Name
                              Expanded(
                                child: Text(
                                  category.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppColors.mainColor
                                        : Colors.black,
                                  ),
                                ),
                              ),

                              // Selection Indicator
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.mainColor,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final iconMap = {
      'Electronics': Icons.devices,
      'Clothing': Icons.checkroom,
      'Books': Icons.book,
      'Sports': Icons.sports_soccer,
      'Home': Icons.home,
      'Tools': Icons.build,
      'Vehicles': Icons.directions_car,
      'Music': Icons.music_note,
      'Art': Icons.palette,
      'Games': Icons.games,
    };
    return iconMap[categoryName] ?? Icons.category;
  }

  @override
  Widget build(BuildContext context) {
    final categoryApi = ref.watch(categoryProvider);

    return InkWell(
      onTap: widget.enabled ? _showCategoryPicker : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Selected Category Image
            if (_selectedCategoryModel != null &&
                _selectedCategoryModel!.fullImageUrl.isNotEmpty)
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CacheImageWidget(
                    url: _selectedCategoryModel!.fullImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else if (_selectedCategoryModel != null)
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  _getCategoryIcon(_selectedCategoryModel!.name),
                  color: AppColors.mainColor,
                  size: 18,
                ),
              )
            else
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.category, color: Colors.grey[500], size: 18),
              ),

            const SizedBox(width: 12),

            // Category Text
            Expanded(
              child: Text(
                _selectedCategoryModel?.name ?? widget.hintText,
                style: TextStyle(
                  color: _selectedCategoryModel != null
                      ? Colors.black
                      : Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),

            // Loading indicator or dropdown arrow
            if (categoryApi.loadingFor == "category")
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.mainColor,
                ),
              )
            else
              Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
