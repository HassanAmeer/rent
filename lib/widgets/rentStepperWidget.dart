// import 'package:flutter/material.dart';

// class ProRentStatusStepper extends StatefulWidget {
//   final String initialStatus;
//   final Function(String) onStatusChanged;

//   // Customizations
//   final double height;
//   final double cornerRadius;
//   final double activeScale;
//   final double stepWidth;
//   final double spacing;
//   final Color progressColor;
//   final Color activeColor;
//   final Color completedColor;
//   final Color inactiveColor;
//   final Color inactiveTextColor;
//   final double fontSize;
//   final double iconSize;

//   const ProRentStatusStepper({
//     Key? key,
//     required this.initialStatus,
//     required this.onStatusChanged,
//     this.height = 42,
//     this.cornerRadius = 5,
//     this.activeScale = 1.1,
//     this.stepWidth = 100,
//     this.spacing = 16,
//     this.progressColor = Colors.blue,
//     this.activeColor = Colors.blue,
//     this.completedColor = Colors.green,
//     this.inactiveColor = const Color(0xFFE0E0E0),
//     this.inactiveTextColor = Colors.grey,
//     this.fontSize = 11.5,
//     this.iconSize = 17,
//   }) : super(key: key);

//   @override
//   State<ProRentStatusStepper> createState() => _ProRentStatusStepperState();
// }

// class _ProRentStatusStepperState extends State<ProRentStatusStepper> {
//   late int _currentIndex;

//   final List<Map<String, String>> _steps = [
//     {'status': 'reject', 'label': 'Rejet'},
//     {'status': 'pending', 'label': 'Pending'},
//     {'status': 'rented', 'label': 'Rented'},
//     {'status': 'closed', 'label': 'Closed'},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = _steps.indexWhere(
//       (s) => s['status'] == widget.initialStatus,
//     );
//     if (_currentIndex == -1) _currentIndex = 0;
//   }

//   void _updateStatus(int index) {
//     setState(() => _currentIndex = index);
//     widget.onStatusChanged(_steps[index]['status']!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final totalWidth = constraints.maxWidth;
//         final totalSteps = _steps.length;
//         final segmentWidth = (totalWidth + widget.spacing) / totalSteps;

//         return SizedBox(
//           height: widget.height + 5,
//           child: Stack(
//             children: [
//               // Background Line
//               Positioned(
//                 top: widget.height / 2 - 2,
//                 left: 0,
//                 right: 0,
//                 child: Container(height: 4, color: widget.inactiveColor),
//               ),

//               // Progress Line (fills up to current step)
//               Positioned(
//                 top: widget.height / 2 - 2,
//                 left: 0,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 350),
//                   curve: Curves.easeInOut,
//                   width:
//                       segmentWidth * (_currentIndex + 1) - widget.spacing / 2,
//                   height: 4,
//                   color: widget.progressColor,
//                 ),
//               ),

//               // Step Boxes
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(totalSteps, (index) {
//                   final step = _steps[index];
//                   final isActive = index == _currentIndex;
//                   final isCompleted = index < _currentIndex;

//                   return GestureDetector(
//                     onTap: () => _updateStatus(index),
//                     child: AnimatedScale(
//                       scale: isActive ? widget.activeScale : 0.8,
//                       duration: const Duration(milliseconds: 220),
//                       curve: Curves.easeOutBack,
//                       child: Container(
//                         width: widget.stepWidth,
//                         height: widget.height,
//                         decoration: BoxDecoration(
//                           color: isActive
//                               ? widget.activeColor
//                               : isCompleted
//                               ? widget.completedColor
//                               : widget.inactiveColor,
//                           borderRadius: BorderRadius.circular(
//                             widget.cornerRadius,
//                           ),
//                           boxShadow: isActive
//                               ? [
//                                   BoxShadow(
//                                     color: widget.activeColor.withOpacity(0.4),
//                                     blurRadius: 8,
//                                     offset: const Offset(0, 3),
//                                   ),
//                                 ]
//                               : null,
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             // Icon
//                             if (isCompleted)
//                               Icon(
//                                 Icons.check,
//                                 size: widget.iconSize,
//                                 color: Colors.white,
//                               )
//                             else if (isActive)
//                               Icon(
//                                 Icons.circle,
//                                 size: widget.iconSize * 0.55,
//                                 color: Colors.white,
//                               )
//                             else
//                               const SizedBox(width: 16),

//                             const SizedBox(width: 5),

//                             // Label Text
//                             Text(
//                               step['label']!,
//                               style: TextStyle(
//                                 color: isActive || isCompleted
//                                     ? Colors.white
//                                     : widget.inactiveTextColor,
//                                 fontSize: widget.fontSize,
//                                 fontWeight: isActive
//                                     ? FontWeight.bold
//                                     : FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// ProRentStatusStepper(
//   initialStatus: widget.data.isRejected.toString() == '1'
//       ? "reject"
//       : widget.data.delivered.toString() == '0'
//       ? "pending"
//       : widget.data.delivered.toString() == '1'
//       ? "rented"
//       : widget.data.delivered.toString() == '2'
//       ? "closed"
//       : 'rented',
//   onStatusChanged: (status) {
//     // print("Status → $status");
//     ref
//         .watch(rentOutProvider)
//         .updateOrderStatus(
//           userId: ref
//               .watch(userDataClass)
//               .userData["id"]
//               .toString(),
//           orderId: widget.data.id,
//           statusId: status == "pending"
//               ? 0
//               : status == "rented"
//               ? 1
//               : status == "closed"
//               ? 2
//               : 0,
//           loadingFor: 'status',
//         );
//   },
//   height: 30,
//   spacing: 10,
//   stepWidth: 90,
//   cornerRadius: 20,
//   activeScale: 1,
//   progressColor: AppColors.mainColor,
//   activeColor: AppColors.mainColor,
//   completedColor: AppColors.mainColor.shade700,
//   inactiveColor: Colors.grey.shade300,
//   inactiveTextColor: Colors.grey.shade600,
//   fontSize: 12,
//   iconSize: 15,
// ),

import 'package:flutter/material.dart';

class StepValue {
  final String status;
  final String label;

  // Background colors
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? completedColor;

  // Progress line color (between this step and next)
  final Color? progressColor;

  // Label text color (used when selected or completed)
  final Color? labelColor;

  // Icons
  final IconData? selectedIcon;
  final IconData? unselectedIcon;
  final IconData? completedIcon;

  StepValue({
    required this.status,
    required this.label,
    this.selectedColor = Colors.teal,
    this.unselectedColor = Colors.teal,
    this.completedColor = Colors.teal,
    this.progressColor = Colors.teal,
    this.labelColor = Colors.teal,
    this.selectedIcon = Icons.circle,
    this.unselectedIcon = Icons.history,
    this.completedIcon = Icons.check,
  });
}

class ProRentStatusStepper extends StatefulWidget {
  final String initialStatus;
  final Function(String) onStatusChanged;

  // Optional: Pass your own steps (must contain *all* required fields)
  final List<StepValue>? steps;

  // Layout only
  final double height;
  final double cornerRadius;
  final double activeScale;
  final double stepWidth;
  final double spacing;
  final double fontSize;
  final double iconSize;
  bool selectAble;

  ProRentStatusStepper({
    super.key,
    required this.initialStatus,
    required this.onStatusChanged,
    this.steps,
    this.height = 35,
    this.cornerRadius = 5,
    this.activeScale = 0.95,
    this.stepWidth = 90,
    this.spacing = 70,
    this.fontSize = 10,
    this.iconSize = 20,
    this.selectAble = true,
  });

  @override
  State<ProRentStatusStepper> createState() => _ProRentStatusStepperState();
}

class _ProRentStatusStepperState extends State<ProRentStatusStepper> {
  late int _currentIndex;
  late List<StepValue> _steps;

  // --------------------------------------------------------------
  // 3. Default steps – **every field is explicitly set**
  // --------------------------------------------------------------
  static final List<StepValue> _defaultSteps = [
    StepValue(
      status: '0',
      label: 'Rejet',
      selectedColor: Colors.red,
      unselectedColor: Colors.grey.shade300,
      completedColor: Colors.grey.shade300,
      progressColor: Colors.grey.shade300,
      labelColor: Colors.white,
      selectedIcon: Icons.cancel,
      unselectedIcon: Icons.close,
      completedIcon: Icons.block,
    ),
    StepValue(
      status: '1',
      label: 'Pending',
      selectedColor: Colors.orange,
      unselectedColor: Colors.grey.shade300,
      completedColor: Colors.grey.shade300,
      progressColor: Colors.cyan,
      labelColor: Colors.white,
      selectedIcon: Icons.circle,
      unselectedIcon: null,
      completedIcon: Icons.history,
    ),
    StepValue(
      status: '2',
      label: 'Rented',
      selectedColor: Colors.cyan,
      unselectedColor: Colors.grey.shade300,
      completedColor: Colors.cyan.shade700,
      progressColor: Colors.cyan,
      labelColor: Colors.white,
      selectedIcon: Icons.circle,
      unselectedIcon: null,
      completedIcon: Icons.check,
    ),
    StepValue(
      status: '3',
      label: 'Closed',
      selectedColor: Colors.cyan,
      unselectedColor: Colors.grey.shade300,
      completedColor: Colors.cyan.shade700,
      progressColor: Colors.cyan,
      labelColor: Colors.white,
      selectedIcon: Icons.circle,
      unselectedIcon: null,
      completedIcon: Icons.check,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _steps = widget.steps?.isNotEmpty == true ? widget.steps! : _defaultSteps;
    _currentIndex = _steps.indexWhere((s) => s.status == widget.initialStatus);
    if (_currentIndex == -1) _currentIndex = 0;
  }

  void _updateStatus(int index) {
    setState(() => _currentIndex = index);
    widget.onStatusChanged(_steps[index].status);
  }

  // --------------------------------------------------------------
  // 4. Helpers – **read directly from the model**
  // --------------------------------------------------------------
  Color? _backgroundColor(int index, bool isActive, bool isCompleted) {
    final step = _steps[index];

    // Special: Reject (index 0) → grey when any other step is selected
    if (index == 0 && _currentIndex > 0) {
      return step.unselectedColor;
    }

    if (isActive) return step.selectedColor;
    if (isCompleted) return step.completedColor;
    return step.unselectedColor;
  }

  Color? _labelColor(int index, bool isActive, bool isCompleted) {
    final step = _steps[index];
    return (isActive || isCompleted) ? step.labelColor : Colors.grey.shade600;
  }

  IconData? _icon(int index, bool isActive, bool isCompleted) {
    final step = _steps[index];
    if (isActive) return step.selectedIcon;
    if (isCompleted) return step.completedIcon;
    return step.unselectedIcon;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final totalSteps = _steps.length;
        final segmentWidth = (totalWidth + widget.spacing) / totalSteps;

        return SizedBox(
          height: widget.height + 5,
          child: Stack(
            children: [
              // Background line (always the *unselected* colour of the first step)
              Positioned(
                top: widget.height / 2 - 2,
                left: 0,
                right: 0,
                child: Container(
                  height: 3,
                  color: _steps.first.unselectedColor,
                ),
              ),

              // Progress line – per-segment colour from the *previous* step
              ...List.generate(_currentIndex, (i) {
                final color = _steps[i].progressColor;
                return Positioned(
                  top: widget.height / 2 - 3,
                  left: segmentWidth * i,
                  child: Container(
                    width: segmentWidth - widget.spacing / 10,
                    height: 5,
                    color: color,
                  ),
                );
              }),

              // Step boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(totalSteps, (index) {
                  final step = _steps[index];
                  final isActive = index == _currentIndex;
                  final isCompleted = index < _currentIndex;

                  final bgColor = _backgroundColor(
                    index,
                    isActive,
                    isCompleted,
                  );
                  final iconData = _icon(index, isActive, isCompleted);
                  final showIcon = iconData != null;

                  return GestureDetector(
                    onTap: widget.selectAble == false
                        ? null
                        : () => _updateStatus(index),
                    child: AnimatedScale(
                      scale: isActive ? widget.activeScale : 0.85,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutBack,
                      child: Container(
                        width: widget.stepWidth,
                        height: widget.height,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(
                            widget.cornerRadius,
                          ),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: step.selectedColor!.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (showIcon)
                              Icon(
                                iconData,
                                size: isActive
                                    ? widget.iconSize * 0.55
                                    : widget.iconSize,
                                color: Colors.white,
                              )
                            else
                              const SizedBox(width: 16),
                            const SizedBox(width: 3),
                            Text(
                              step.label,
                              style: TextStyle(
                                color: _labelColor(
                                  index,
                                  isActive,
                                  isCompleted,
                                ),
                                fontSize: widget.fontSize,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
