import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/booking_confirmation_widget.dart';
import './widgets/booking_progress_indicator.dart';
import './widgets/datetime_selection_widget.dart';
import './widgets/manicurist_selection_widget.dart';
import './widgets/service_selection_widget.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();
  bool _isLoading = false;

  // Selection state
  List<int> _selectedServiceIds = [];
  int? _selectedManicuristId;
  DateTime? _selectedDate;
  String? _selectedTime;
  double _totalAmount = 0.0;

  final List<String> _stepTitles = [
    'Servicios',
    'Manicurista',
    'Fecha y Hora',
    'Confirmación'
  ];

  // Mock data
  final List<Map<String, dynamic>> _services = [
    {
      "id": 1,
      "name": "Manicura Clásica",
      "description": "Manicura tradicional con esmaltado básico",
      "price": "\$25.00",
      "duration": 45,
      "image":
          "https://images.pexels.com/photos/3997379/pexels-photo-3997379.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 2,
      "name": "Manicura Francesa",
      "description": "Elegante manicura francesa con acabado perfecto",
      "price": "\$35.00",
      "duration": 60,
      "image":
          "https://images.pexels.com/photos/3997982/pexels-photo-3997982.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 3,
      "name": "Uñas de Gel",
      "description": "Uñas de gel duraderas con acabado brillante",
      "price": "\$45.00",
      "duration": 90,
      "image":
          "https://images.pexels.com/photos/3997991/pexels-photo-3997991.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 4,
      "name": "Nail Art",
      "description": "Diseños artísticos personalizados en tus uñas",
      "price": "\$55.00",
      "duration": 120,
      "image":
          "https://images.pexels.com/photos/3997386/pexels-photo-3997386.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 5,
      "name": "Pedicura Spa",
      "description": "Pedicura relajante con tratamiento hidratante",
      "price": "\$40.00",
      "duration": 75,
      "image":
          "https://images.pexels.com/photos/3997983/pexels-photo-3997983.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 6,
      "name": "Tratamiento Cutículas",
      "description": "Cuidado especializado para cutículas saludables",
      "price": "\$20.00",
      "duration": 30,
      "image":
          "https://images.pexels.com/photos/3997388/pexels-photo-3997388.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
  ];

  final List<Map<String, dynamic>> _manicurists = [
    {
      "id": 1,
      "name": "María González",
      "photo":
          "https://images.pexels.com/photos/3762800/pexels-photo-3762800.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "rating": 4.9,
      "reviews": 127,
      "specialty": "Especialista en Nail Art y Gel",
      "available": true,
    },
    {
      "id": 2,
      "name": "Carmen López",
      "photo":
          "https://images.pexels.com/photos/3762811/pexels-photo-3762811.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "rating": 4.8,
      "reviews": 98,
      "specialty": "Manicura Francesa y Clásica",
      "available": true,
    },
    {
      "id": 3,
      "name": "Ana Martínez",
      "photo":
          "https://images.pexels.com/photos/3762806/pexels-photo-3762806.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "rating": 4.7,
      "reviews": 156,
      "specialty": "Pedicura Spa y Tratamientos",
      "available": false,
    },
    {
      "id": 4,
      "name": "Isabel Rodríguez",
      "photo":
          "https://images.pexels.com/photos/3762795/pexels-photo-3762795.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "rating": 4.9,
      "reviews": 203,
      "specialty": "Uñas Acrílicas y Extensiones",
      "available": true,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          BookingProgressIndicator(
            currentStep: _currentStep,
            stepTitles: _stepTitles,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ServiceSelectionWidget(
                  services: _services,
                  selectedServiceIds: _selectedServiceIds,
                  onSelectionChanged: (selectedIds) {
                    setState(() {
                      _selectedServiceIds = selectedIds;
                    });
                  },
                  onTotalChanged: (total) {
                    setState(() {
                      _totalAmount = total;
                    });
                  },
                ),
                ManicuristSelectionWidget(
                  manicurists: _manicurists,
                  selectedManicuristId: _selectedManicuristId,
                  onSelectionChanged: (manicuristId) {
                    setState(() {
                      _selectedManicuristId = manicuristId;
                    });
                  },
                ),
                DateTimeSelectionWidget(
                  selectedDate: _selectedDate,
                  selectedTime: _selectedTime,
                  onDateChanged: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  onTimeChanged: (time) {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                ),
                BookingConfirmationWidget(
                  selectedServices: _getSelectedServices(),
                  selectedManicurist: _getSelectedManicurist(),
                  selectedDate: _selectedDate,
                  selectedTime: _selectedTime,
                  totalAmount: _totalAmount,
                  onConfirmBooking: _confirmBooking,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
          if (_currentStep < 3) _buildNavigationButtons(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          if (_currentStep > 0) {
            _previousStep();
          } else {
            Navigator.pop(context);
          }
        },
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Text(
        'Reservar Cita',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        if (_currentStep > 0)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Anterior',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            if (_currentStep > 0) SizedBox(width: 4.w),
            Expanded(
              flex: _currentStep == 0 ? 1 : 1,
              child: ElevatedButton(
                onPressed: _canProceed() ? _nextStep : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _currentStep == 2 ? 'Revisar' : 'Siguiente',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedServiceIds.isNotEmpty;
      case 1:
        return _selectedManicuristId != null;
      case 2:
        return _selectedDate != null && _selectedTime != null;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  List<Map<String, dynamic>> _getSelectedServices() {
    return _services
        .where((service) => _selectedServiceIds.contains(service['id'] as int))
        .toList();
  }

  Map<String, dynamic>? _getSelectedManicurist() {
    if (_selectedManicuristId == null) return null;
    return _manicurists.firstWhere(
      (manicurist) => manicurist['id'] == _selectedManicuristId,
      orElse: () => {},
    );
  }

  Future<void> _confirmBooking() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(
            'Error al confirmar la cita. Por favor, inténtalo de nuevo.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: Colors.green,
                size: 48,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              '¡Cita confirmada!',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Tu cita ha sido reservada exitosamente. Recibirás una confirmación por email.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Aceptar',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'Error',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Aceptar',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
