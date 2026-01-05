import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:rent/constants/appColors.dart';

/// Calendar theme configuration matching app colors
class CalendarTheme {
  /// Get calendar config with app theme colors
  static CalendarDatePicker2WithActionButtonsConfig getConfig({
    CalendarDatePicker2Type type = CalendarDatePicker2Type.range,
  }) {
    return CalendarDatePicker2WithActionButtonsConfig(
      calendarType: type,

      // ✅ Selected date colors (Cyan theme)
      selectedDayHighlightColor: AppColors.mainColor,
      selectedDayTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),

      // ✅ Date tap/click splash color (Cyan theme)
      daySplashColor: AppColors.mainColor.withOpacity(0.3),

      // ✅ Range selection colors
      selectedRangeHighlightColor: AppColors.mainColor.withOpacity(0.2),

      // ✅ Today's date
      todayTextStyle: TextStyle(
        color: AppColors.mainColor,
        fontWeight: FontWeight.bold,
      ),

      // ✅ Action buttons styling
      okButton: Text(
        'Book Now',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: AppColors.mainColor,
        ),
      ),
      cancelButton: Text(
        'Cancel',
        style: TextStyle(fontSize: 16, color: AppColors.mainColor),
      ),

      // ✅ Weekday labels
      weekdayLabelTextStyle: TextStyle(
        color: AppColors.mainColor.shade700,
        fontWeight: FontWeight.w600,
      ),

      // ✅ Month/Year selector
      controlsTextStyle: TextStyle(
        color: AppColors.mainColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),

      // ✅ Other styling
      dayTextStyle: const TextStyle(color: Colors.black87),
      disabledDayTextStyle: const TextStyle(color: Colors.grey),

      // ✅ Behavior
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      currentDate: DateTime.now(),
    );
  }
}
