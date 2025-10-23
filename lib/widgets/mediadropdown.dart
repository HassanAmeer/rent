import 'package:flutter/material.dart';

import '../constants/appColors.dart';

// Item class to hold dropdown data
class DropdownItem {
  final String title;
  final String? subtitle;
  final Widget? image;
  final dynamic value;

  DropdownItem({
    required this.title,
    this.subtitle,
    this.image,
    required this.value,
  });
}

// Custom Dropdown Widget
class MediaDropdown extends StatefulWidget {
  final List<DropdownItem> items;
  final Function(int index, dynamic value)? onSelected;
  final Function(int index)? onTap;
  final Function()? onArrowTap;
  final String? hint;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? hintStyle;
  final Color? dropdownBackgroundColor;
  final Color borderColor;
  final Color loadingValueColor;
  final Color loadingBackgroundColor;
  final Color arrowIconColor;
  final IconData arrowIcon;
  final double loaderStrokeWidth;
  final double loaderRightPadding;
  final double borderWidth;
  final double? width;
  final double? height;
  final double borderRadius;
  final Widget? leadingWidget;
  final bool? isLoading;
  final double? elevation;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const MediaDropdown({
    super.key,
    required this.items,
    this.onSelected,
    this.onTap,
    this.onArrowTap,
    this.hint,
    this.titleStyle,
    this.subtitleStyle,
    this.hintStyle,
    this.dropdownBackgroundColor,
    this.borderColor = Colors.grey,
    this.loadingValueColor = AppColors.mainColor,
    this.loadingBackgroundColor = Colors.grey,
    this.arrowIconColor = Colors.grey,
    this.loaderStrokeWidth = 2,
    this.loaderRightPadding = 10,
    this.borderWidth = 1,
    this.arrowIcon = Icons.keyboard_double_arrow_down,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.leadingWidget,
    this.elevation,
    this.padding,
    this.margin,
    this.isLoading = false,
  });

  @override
  MediaDropdownState createState() => MediaDropdownState();
}

class MediaDropdownState extends State<MediaDropdown> {
  int? _selectedIndex;
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  // Toggle dropdown visibility
  void _toggleDropdown() {
    if (_overlayEntry != null) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  // Open dropdown menu
  void _openDropdown() {
    final RenderBox? renderBox =
        _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenSize = MediaQuery.of(context).size;
    final safePadding = MediaQuery.of(context).padding;

    // Calculate available space below the dropdown
    final availableHeightBelow =
        screenSize.height - position.dy - size.height - safePadding.bottom;
    final maxDropdownHeight = (availableHeightBelow * 0.6).clamp(
      100.0,
      300.0,
    ); // Responsive height

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dismiss dropdown when tapping outside
          GestureDetector(
            onTap: _closeDropdown,
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            left: position.dx,
            top: position.dy + (widget.height ?? size.height),
            width: size.width.clamp(
              200.0,
              screenSize.width * 0.9,
            ), // Responsive width
            child: Material(
              elevation: widget.elevation ?? 4,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.dropdownBackgroundColor ?? Colors.white,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                constraints: BoxConstraints(
                  maxHeight: maxDropdownHeight, // Prevent overflow
                  minHeight: 0,
                  maxWidth:
                      screenSize.width * 0.9, // Max width for smaller screens
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        widget.onSelected?.call(index, item.value);
                        _closeDropdown();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              screenSize.width * 0.04, // Responsive padding
                          vertical: screenSize.height * 0.01,
                        ),
                        child: Row(
                          children: [
                            if (widget.leadingWidget != null) ...[
                              widget.leadingWidget!,
                              SizedBox(width: screenSize.width * 0.02),
                            ],
                            if (item.image != null) ...[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                clipBehavior: Clip.antiAlias,
                                width: screenSize.width * 0.06,
                                child: item.image!,
                              ),
                              SizedBox(width: screenSize.width * 0.02),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.title,
                                    style:
                                        widget.titleStyle?.copyWith(
                                          fontSize:
                                              (widget.titleStyle?.fontSize ??
                                                  16) *
                                              (screenSize.width < 600
                                                  ? 0.9
                                                  : 1.0), // Scale font
                                        ) ??
                                        TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: screenSize.width < 600
                                              ? 14
                                              : 16,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (item.subtitle != null)
                                    Text(
                                      item.subtitle!,
                                      style:
                                          widget.subtitleStyle?.copyWith(
                                            fontSize:
                                                (widget
                                                        .subtitleStyle
                                                        ?.fontSize ??
                                                    14) *
                                                (screenSize.width < 600
                                                    ? 0.9
                                                    : 1.0),
                                          ) ??
                                          TextStyle(
                                            fontSize: screenSize.width < 600
                                                ? 12
                                                : 14,
                                            color: Colors.grey,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  // Close dropdown menu
  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;
    final isTablet = screenSize.width >= 600 && screenSize.width < 1024;
    final isDesktop = screenSize.width >= 1024;

    // Handle empty items
    if (widget.items.isEmpty) {
      return Container(
        width: widget.width ?? screenSize.width * 0.9, // Responsive width
        height: widget.height ?? (isMobile ? 50 : 60),
        margin:
            widget.margin ??
            EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                widget.hint ?? 'No items available',
                style:
                    widget.hintStyle?.copyWith(
                      fontSize:
                          (widget.hintStyle?.fontSize ?? 16) *
                          (isMobile ? 0.9 : 1.0),
                    ) ??
                    TextStyle(color: Colors.grey, fontSize: isMobile ? 14 : 16),
              ),
            ),
            widget.isLoading!
                ? Padding(
                    padding: EdgeInsets.only(right: widget.loaderRightPadding),
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        color: widget.loadingValueColor,
                        backgroundColor: widget.loadingBackgroundColor,
                        strokeWidth: widget.loaderStrokeWidth,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      widget.onArrowTap?.call();
                      _toggleDropdown();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.02,
                      ),
                      child: Icon(
                        widget.arrowIcon,
                        color: widget.arrowIconColor,
                        size: isMobile ? 20 : 24, // Responsive icon size
                      ),
                    ),
                  ),
          ],
        ),
      );
    }

    // Selected item or hint
    final selectedItem = _selectedIndex != null
        ? widget.items[_selectedIndex!]
        : null;

    return GestureDetector(
      key: _dropdownKey,
      onTap: () {
        if (_selectedIndex != null) {
          widget.onTap?.call(_selectedIndex!);
        }
        _toggleDropdown();
      },
      child: Container(
        width: widget.width ?? screenSize.width * 0.9, // Responsive width
        height:
            widget.height ??
            (isMobile
                ? 55
                : isTablet
                ? 60
                : 70),
        margin:
            widget.margin ??
            EdgeInsets.symmetric(vertical: screenSize.height * 0.0),
        padding:
            widget.padding ??
            EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.02,
              vertical: screenSize.height * 0.0,
            ),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Row(
          children: [
            // if (widget.leadingWidget != null) ...[
            //   widget.leadingWidget!,
            //   SizedBox(width: screenSize.width * 0.02),
            // ],
            if (selectedItem != null && selectedItem.image != null) ...[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                clipBehavior: Clip.antiAlias,
                width: screenSize.width * 0.06,
                child: selectedItem.image!,
              ),
              SizedBox(width: screenSize.width * 0.02),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedItem?.title ?? widget.hint ?? 'Select an option',
                    style: selectedItem != null
                        ? (widget.titleStyle?.copyWith(
                                fontSize:
                                    (widget.titleStyle?.fontSize ?? 16) *
                                    (isMobile ? 0.9 : 1.0),
                              ) ??
                              TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: isMobile ? 14 : 16,
                              ))
                        : (widget.hintStyle?.copyWith(
                                fontSize:
                                    (widget.hintStyle?.fontSize ?? 16) *
                                    (isMobile ? 0.9 : 1.0),
                              ) ??
                              TextStyle(
                                color: Colors.grey,
                                fontSize: isMobile ? 14 : 16,
                              )),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (selectedItem != null && selectedItem.subtitle != null)
                    Text(
                      selectedItem.subtitle!,
                      style:
                          widget.subtitleStyle?.copyWith(
                            fontSize:
                                (widget.subtitleStyle?.fontSize ?? 12) *
                                (isMobile ? 0.9 : 1.0),
                          ) ??
                          TextStyle(
                            fontSize: isMobile ? 10 : 12,
                            color: Colors.grey,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            widget.isLoading!
                ? Padding(
                    padding: EdgeInsets.only(right: widget.loaderRightPadding),
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        color: widget.loadingValueColor,
                        backgroundColor: widget.loadingBackgroundColor,
                        strokeWidth: widget.loaderStrokeWidth,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      widget.onArrowTap?.call();
                      _toggleDropdown();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.02,
                      ),
                      child: Icon(
                        widget.arrowIcon,
                        color: widget.arrowIconColor,
                        size: isMobile ? 20 : 24, // Responsive icon size
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// // Example Usage
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Responsive Dropdown')),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: MediaDropdown(
//               items: [
//                 DropdownItem(
//                   title: 'Option 1',
//                   subtitle: 'Description 1',
//                   image: const Icon(Icons.star, color: Colors.amber),
//                   value: 'option1',
//                 ),
//                 DropdownItem(
//                   title: 'Option 2',
//                   image: const Icon(Icons.favorite, color: Colors.red),
//                   value: 'option2',
//                 ),
//                 DropdownItem(
//                   title: 'Option 3',
//                   subtitle: 'Description 3',
//                   value: 'option3',
//                 ),
//               ],
//               hint: 'Select an option',
//               onSelected: (index, value) {
//                 print('Selected index: $index, value: $value');
//               },
//               onTap: (index) {
//                 print('Item tapped: $index');
//               },
//               onArrowTap: (index) {
//                 print('Arrow tapped: $index');
//               },
//               titleStyle: TextStyle(
//                 fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 18,
//                 fontWeight: FontWeight.bold,
//               ),
//               subtitleStyle: TextStyle(
//                 fontSize: MediaQuery.of(context).size.width < 600 ? 12 : 14,
//                 color: Colors.blueGrey,
//               ),
//               hintStyle: TextStyle(
//                 fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 16,
//                 color: Colors.grey,
//               ),
//               dropdownBackgroundColor: Colors.white,
//               borderColor: Colors.blue,
//               borderWidth: 2,
//               borderRadius: BorderRadius.circular(12),
//               elevation: 4,
//               padding: EdgeInsets.symmetric(
//                 horizontal: MediaQuery.of(context).size.width * 0.04,
//                 vertical: MediaQuery.of(context).size.height * 0.015,
//               ),
//               margin: EdgeInsets.symmetric(
//                 vertical: MediaQuery.of(context).size.height * 0.01,
//               ),
//               leadingWidget: const Icon(Icons.category, color: Colors.green),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
