import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DateTimeSelectionWidget extends StatefulWidget {
  final DateTime? selectedDate;
  final String? selectedTime;
  final Function(DateTime) onDateChanged;
  final Function(String) onTimeChanged;

  const DateTimeSelectionWidget({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateChanged,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  State<DateTimeSelectionWidget> createState() =>
      _DateTimeSelectionWidgetState();
}

class _DateTimeSelectionWidgetState extends State<DateTimeSelectionWidget> {
  late DateTime _currentMonth;
  final List<String> _timeSlots = [
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00'
  ];

  final List<String> _unavailableSlots = ['10:30', '14:00', '16:30', '19:00'];

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Text(
            'Selecciona fecha y hora',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildCalendar(),
                SizedBox(height: 2.h),
                if (widget.selectedDate != null) _buildTimeSlots(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildCalendarHeader(),
          SizedBox(height: 2.h),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    final monthNames = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _currentMonth =
                  DateTime(_currentMonth.year, _currentMonth.month - 1);
            });
          },
          icon: CustomIconWidget(
            iconName: 'chevron_left',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
        ),
        Text(
          '${monthNames[_currentMonth.month - 1]} ${_currentMonth.year}',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _currentMonth =
                  DateTime(_currentMonth.year, _currentMonth.month + 1);
            });
          },
          icon: CustomIconWidget(
            iconName: 'chevron_right',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final daysOfWeek = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday - 1;
    final today = DateTime.now();

    return Column(
      children: [
        // Days of week header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: daysOfWeek
              .map((day) => Container(
                    width: 10.w,
                    height: 6.h,
                    alignment: Alignment.center,
                    child: Text(
                      day,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ))
              .toList(),
        ),
        // Calendar days
        ...List.generate(6, (weekIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (dayIndex) {
              final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 1;

              if (dayNumber < 1 || dayNumber > lastDayOfMonth.day) {
                return Container(width: 10.w, height: 6.h);
              }

              final date =
                  DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
              final isToday = date.day == today.day &&
                  date.month == today.month &&
                  date.year == today.year;
              final isSelected = widget.selectedDate != null &&
                  date.day == widget.selectedDate!.day &&
                  date.month == widget.selectedDate!.month &&
                  date.year == widget.selectedDate!.year;
              final isPast =
                  date.isBefore(today.subtract(const Duration(days: 1)));
              final isAvailable = !isPast && _isDateAvailable(date);

              return GestureDetector(
                onTap: isAvailable ? () => widget.onDateChanged(date) : null,
                child: Container(
                  width: 10.w,
                  height: 6.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : isToday
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.2)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday && !isSelected
                        ? Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 1,
                          )
                        : null,
                  ),
                  child: Text(
                    dayNumber.toString(),
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : !isAvailable
                              ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5)
                              : isToday
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: isSelected || isToday
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _buildTimeSlots() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Text(
              'Horarios disponibles',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 25.h,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 1.h,
              ),
              itemCount: _timeSlots.length,
              itemBuilder: (context, index) {
                final timeSlot = _timeSlots[index];
                final isSelected = widget.selectedTime == timeSlot;
                final isUnavailable = _unavailableSlots.contains(timeSlot);

                return GestureDetector(
                  onTap: !isUnavailable
                      ? () => widget.onTimeChanged(timeSlot)
                      : null,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isUnavailable
                          ? AppTheme.lightTheme.colorScheme.surface
                              .withValues(alpha: 0.5)
                          : isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      timeSlot,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isUnavailable
                            ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5)
                            : isSelected
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_unavailableSlots.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Los horarios en gris no están disponibles',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  bool _isDateAvailable(DateTime date) {
    // Mock availability logic - in real app, this would check with API
    final dayOfWeek = date.weekday;
    return dayOfWeek != 7; // Not available on Sundays
  }
}
