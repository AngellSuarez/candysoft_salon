import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingProgressIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> stepTitles;

  const BookingProgressIndicator({
    Key? key,
    required this.currentStep,
    required this.stepTitles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(stepTitles.length, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;
              final isLast = index == stepTitles.length - 1;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: isCompleted || isCurrent
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.outline,
                              shape: BoxShape.circle,
                              border: isCurrent
                                  ? Border.all(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: isCompleted
                                ? CustomIconWidget(
                                    iconName: 'check',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    size: 16,
                                  )
                                : Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: isCurrent
                                            ? AppTheme.lightTheme.colorScheme
                                                .onPrimary
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            stepTitles[index],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isCurrent
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : isCompleted
                                      ? AppTheme
                                          .lightTheme.colorScheme.onSurface
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                              fontWeight:
                                  isCurrent ? FontWeight.w600 : FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 8.w,
                        height: 2,
                        margin: EdgeInsets.only(bottom: 4.h),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
