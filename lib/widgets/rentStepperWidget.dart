import 'package:flutter/material.dart';

class ProRentStatusStepper extends StatefulWidget {
  final String initialStatus;
  final Function(String) onStatusChanged;

  // Customizations
  final double height;
  final double cornerRadius;
  final double activeScale;
  final double stepWidth;
  final double spacing;
  final Color progressColor;
  final Color activeColor;
  final Color completedColor;
  final Color inactiveColor;
  final Color inactiveTextColor;
  final double fontSize;
  final double iconSize;

  const ProRentStatusStepper({
    Key? key,
    required this.initialStatus,
    required this.onStatusChanged,
    this.height = 42,
    this.cornerRadius = 5,
    this.activeScale = 1.1,
    this.stepWidth = 100,
    this.spacing = 16,
    this.progressColor = Colors.blue,
    this.activeColor = Colors.blue,
    this.completedColor = Colors.green,
    this.inactiveColor = const Color(0xFFE0E0E0),
    this.inactiveTextColor = Colors.grey,
    this.fontSize = 11.5,
    this.iconSize = 17,
  }) : super(key: key);

  @override
  State<ProRentStatusStepper> createState() => _ProRentStatusStepperState();
}

class _ProRentStatusStepperState extends State<ProRentStatusStepper> {
  late int _currentIndex;

  final List<Map<String, String>> _steps = [
    {'status': 'reject', 'label': 'Rejet'},
    {'status': 'pending', 'label': 'Pending'},
    {'status': 'rented', 'label': 'Rented'},
    {'status': 'closed', 'label': 'Closed'},
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = _steps.indexWhere(
      (s) => s['status'] == widget.initialStatus,
    );
    if (_currentIndex == -1) _currentIndex = 0;
  }

  void _updateStatus(int index) {
    setState(() => _currentIndex = index);
    widget.onStatusChanged(_steps[index]['status']!);
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
              // Background Line
              Positioned(
                top: widget.height / 2 - 2,
                left: 0,
                right: 0,
                child: Container(height: 4, color: widget.inactiveColor),
              ),

              // Progress Line (fills up to current step)
              Positioned(
                top: widget.height / 2 - 2,
                left: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  width:
                      segmentWidth * (_currentIndex + 1) - widget.spacing / 2,
                  height: 4,
                  color: widget.progressColor,
                ),
              ),

              // Step Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(totalSteps, (index) {
                  final step = _steps[index];
                  final isActive = index == _currentIndex;
                  final isCompleted = index < _currentIndex;

                  return GestureDetector(
                    onTap: () => _updateStatus(index),
                    child: AnimatedScale(
                      scale: isActive ? widget.activeScale : 0.8,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutBack,
                      child: Container(
                        width: widget.stepWidth,
                        height: widget.height,
                        decoration: BoxDecoration(
                          color: isActive
                              ? widget.activeColor
                              : isCompleted
                              ? widget.completedColor
                              : widget.inactiveColor,
                          borderRadius: BorderRadius.circular(
                            widget.cornerRadius,
                          ),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: widget.activeColor.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon
                            if (isCompleted)
                              Icon(
                                Icons.check,
                                size: widget.iconSize,
                                color: Colors.white,
                              )
                            else if (isActive)
                              Icon(
                                Icons.circle,
                                size: widget.iconSize * 0.55,
                                color: Colors.white,
                              )
                            else
                              const SizedBox(width: 16),

                            const SizedBox(width: 5),

                            // Label Text
                            Text(
                              step['label']!,
                              style: TextStyle(
                                color: isActive || isCompleted
                                    ? Colors.white
                                    : widget.inactiveTextColor,
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
