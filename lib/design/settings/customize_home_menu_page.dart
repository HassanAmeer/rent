import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/constants/appColors.dart';
import 'package:rent/models/home_menu_item.dart';
import 'package:rent/providers/home_menu_provider.dart';

class CustomizeHomeMenuPage extends ConsumerStatefulWidget {
  const CustomizeHomeMenuPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomizeHomeMenuPage> createState() =>
      _CustomizeHomeMenuPageState();
}

class _CustomizeHomeMenuPageState extends ConsumerState<CustomizeHomeMenuPage> {
  @override
  Widget build(BuildContext context) {
    final menuManager = ref.watch(homeMenuProvider);
    final menuItems = menuManager.menuItems;
    final availableItems = menuManager.getAvailableItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Home Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset to Default?'),
                  content: const Text(
                    'This will restore the original menu items.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await ref.read(homeMenuProvider).resetToDefault();
              }
            },
            tooltip: 'Reset to default',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Menu Items Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  'Current Menu Items',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${menuItems.length} items',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Reorderable List
          Expanded(
            flex: 2,
            child: menuItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No menu items yet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add items from the list below',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: menuItems.length,
                    onReorder: (oldIndex, newIndex) {
                      ref
                          .read(homeMenuProvider)
                          .reorderItems(oldIndex, newIndex);
                    },
                    itemBuilder: (context, index) {
                      final item = menuItems[index];
                      return Container(
                        key: ValueKey(item.id),
                        child: Card(
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          child: ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.drag_handle,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    item.icon,
                                    color: AppColors.mainColor,
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                              item.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text('Order: ${index + 1}'),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                await ref
                                    .read(homeMenuProvider)
                                    .removeMenuItem(item.id);
                              },
                            ),
                          ),
                        ).animate().fadeIn(delay: (index * 50).milliseconds),
                      );
                    },
                  ),
          ),

          const Divider(thickness: 8, height: 8),

          // Available Items Section
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Text(
                  'Available Options',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${availableItems.length} available',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Available Items Grid
          Expanded(
            flex: 1,
            child: availableItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 64,
                          color: Colors.green[400],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'All items added!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.9,
                        ),
                    itemCount: availableItems.length,
                    itemBuilder: (context, index) {
                      final item = availableItems[index];
                      return InkWell(
                            onTap: () async {
                              await ref
                                  .read(homeMenuProvider)
                                  .addMenuItem(item.id);
                            },
                            child: Card(
                              color: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.mainColor.withOpacity(
                                        0.1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      item.icon,
                                      size: 25,
                                      color: AppColors.mainColor,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    item.label,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  const Icon(
                                    Icons.add_circle_outline,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(delay: (index * 50).milliseconds)
                          .scale(begin: const Offset(0.8, 0.8));
                    },
                  ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
