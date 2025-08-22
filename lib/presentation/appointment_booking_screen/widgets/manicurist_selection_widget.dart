import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ManicuristSelectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> manicurists;
  final int? selectedManicuristId;
  final Function(int) onSelectionChanged;

  const ManicuristSelectionWidget({
    Key? key,
    required this.manicurists,
    required this.selectedManicuristId,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<ManicuristSelectionWidget> createState() =>
      _ManicuristSelectionWidgetState();
}

class _ManicuristSelectionWidgetState extends State<ManicuristSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Text(
            'Selecciona tu manicurista',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: widget.manicurists.length,
            itemBuilder: (context, index) {
              final manicurist = widget.manicurists[index];
              final isSelected =
                  widget.selectedManicuristId == manicurist['id'] as int;
              final isAvailable = manicurist['available'] as bool;

              return Container(
                margin: EdgeInsets.only(bottom: 2.h),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isAvailable
                        ? () =>
                            widget.onSelectionChanged(manicurist['id'] as int)
                        : null,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline,
                          width: isSelected ? 2 : 1,
                        ),
                        color: !isAvailable
                            ? AppTheme.lightTheme.colorScheme.surface
                                .withValues(alpha: 0.5)
                            : isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1)
                                : AppTheme.lightTheme.colorScheme.surface,
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CustomImageWidget(
                                  imageUrl: manicurist['photo'] as String,
                                  width: 20.w,
                                  height: 20.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 1.w,
                                right: 1.w,
                                child: Container(
                                  width: 3.w,
                                  height: 3.w,
                                  decoration: BoxDecoration(
                                    color:
                                        isAvailable ? Colors.green : Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppTheme
                                          .lightTheme.colorScheme.surface,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  manicurist['name'] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: !isAvailable
                                        ? AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant
                                        : null,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'star',
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      '${manicurist['rating']}',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: !isAvailable
                                            ? AppTheme.lightTheme.colorScheme
                                                .onSurfaceVariant
                                            : null,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      '(${manicurist['reviews']} reseñas)',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  manicurist['specialty'] as String,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: isAvailable
                                        ? Colors.green.withValues(alpha: 0.1)
                                        : Colors.red.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    isAvailable
                                        ? 'Disponible'
                                        : 'No disponible',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: isAvailable
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected && isAvailable)
                            Container(
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'check',
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
