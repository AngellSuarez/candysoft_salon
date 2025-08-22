import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/book_appointment_card.dart';
import './widgets/client_greeting_header.dart';
import './widgets/recent_appointments_list.dart';
import './widgets/service_categories_list.dart';
import './widgets/upcoming_appointment_card.dart';

class ClientDashboard extends StatefulWidget {
  const ClientDashboard({Key? key}) : super(key: key);

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;
  bool _isLoading = false;

  // Mock data for client dashboard
  final Map<String, dynamic> clientData = {
    "name": "María González",
    "loyaltyStatus": "Cliente VIP",
    "loyaltyPoints": 1250,
  };

  final Map<String, dynamic> upcomingAppointment = {
    "date": "Viernes, 23 Agosto",
    "time": "14:30",
    "service": "Manicura Francesa + Pedicura",
    "manicurist": "Ana Rodríguez",
    "status": "Confirmada",
  };

  final List<Map<String, dynamic>> serviceCategories = [
    {
      "id": 1,
      "name": "Manicura",
      "image":
          "https://images.pexels.com/photos/3997379/pexels-photo-3997379.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": 2,
      "name": "Pedicura",
      "image":
          "https://images.pexels.com/photos/3997993/pexels-photo-3997993.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": 3,
      "name": "Uñas Gel",
      "image":
          "https://images.pexels.com/photos/3997386/pexels-photo-3997386.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": 4,
      "name": "Nail Art",
      "image":
          "https://images.pexels.com/photos/3997992/pexels-photo-3997992.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": 5,
      "name": "Tratamientos",
      "image":
          "https://images.pexels.com/photos/3997991/pexels-photo-3997991.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
  ];

  final List<Map<String, dynamic>> recentAppointments = [
    {
      "id": 1,
      "service": "Manicura Clásica",
      "date": "15 Agosto 2025",
      "time": "16:00",
      "manicurist": "Carmen López",
      "status": "Completada",
      "rated": false,
      "serviceImage":
          "https://images.pexels.com/photos/3997379/pexels-photo-3997379.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": 2,
      "service": "Pedicura Spa",
      "date": "08 Agosto 2025",
      "time": "11:30",
      "manicurist": "Ana Rodríguez",
      "status": "Completada",
      "rated": true,
      "serviceImage":
          "https://images.pexels.com/photos/3997993/pexels-photo-3997993.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": 3,
      "service": "Uñas Gel Decoradas",
      "date": "01 Agosto 2025",
      "time": "13:15",
      "manicurist": "Isabel Martín",
      "status": "Completada",
      "rated": true,
      "serviceImage":
          "https://images.pexels.com/photos/3997386/pexels-photo-3997386.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _onRescheduleAppointment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reprogramar Cita',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          '¿Deseas reprogramar tu cita del ${upcomingAppointment['date']} a las ${upcomingAppointment['time']}?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/appointment-booking-screen');
            },
            child: const Text('Reprogramar'),
          ),
        ],
      ),
    );
  }

  void _onCancelAppointment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancelar Cita',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.error,
          ),
        ),
        content: Text(
          '¿Estás segura de que deseas cancelar tu cita del ${upcomingAppointment['date']}? Esta acción no se puede deshacer.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, mantener'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cita cancelada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }

  void _onCategoryTap(Map<String, dynamic> category) {
    Navigator.pushNamed(context, '/service-management-screen');
  }

  void _onBookAppointment() {
    Navigator.pushNamed(context, '/appointment-booking-screen');
  }

  void _onAppointmentTap(Map<String, dynamic> appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Detalles de la Cita',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomImageWidget(
                    imageUrl: appointment['serviceImage'] as String,
                    width: 20.w,
                    height: 10.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment['service'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${appointment['date']} • ${appointment['time']}',
                        style: AppTheme.dataTextStyle(isLight: true),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        appointment['manicurist'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              'Preparación recomendada:',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              '• Llega 5 minutos antes de tu cita\n• Retira cualquier esmalte previo\n• Mantén las uñas limpias y secas',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _onRateService(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Calificar Servicio',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '¿Cómo fue tu experiencia con ${appointment['service']}?',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Gracias por tu calificación!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    child: CustomIconWidget(
                      iconName: 'star_border',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 32,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Más tarde'),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClientGreetingHeader(
              clientName: clientData['name'] as String,
              loyaltyStatus: clientData['loyaltyStatus'] as String?,
              loyaltyPoints: clientData['loyaltyPoints'] as int?,
            ),
            SizedBox(height: 2.h),
            UpcomingAppointmentCard(
              appointment: upcomingAppointment,
              onReschedule: _onRescheduleAppointment,
              onCancel: _onCancelAppointment,
            ),
            SizedBox(height: 2.h),
            ServiceCategoriesList(
              categories: serviceCategories,
              onCategoryTap: _onCategoryTap,
            ),
            SizedBox(height: 2.h),
            BookAppointmentCard(
              onBookAppointment: _onBookAppointment,
            ),
            SizedBox(height: 2.h),
            RecentAppointmentsList(
              appointments: recentAppointments,
              onAppointmentTap: _onAppointmentTap,
              onRateService: _onRateService,
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'spa',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Servicios',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Explora nuestros servicios de belleza',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/service-management-screen'),
            child: const Text('Ver Servicios'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'event',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Mis Citas',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Gestiona todas tus citas aquí',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: _onBookAppointment,
            child: const Text('Nueva Cita'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 48,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            clientData['name'] as String,
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            clientData['loyaltyStatus'] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          OutlinedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cerrar Sesión'),
                  content:
                      const Text('¿Estás segura de que deseas cerrar sesión?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/registration-screen',
                          (route) => false,
                        );
                      },
                      child: const Text('Cerrar Sesión'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildHomeTab(),
                _buildServicesTab(),
                _buildAppointmentsTab(),
                _buildProfileTab(),
              ],
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'home',
                color: _currentIndex == 0
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              text: 'Inicio',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'spa',
                color: _currentIndex == 1
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              text: 'Servicios',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'event',
                color: _currentIndex == 2
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              text: 'Mis Citas',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'person',
                color: _currentIndex == 3
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              text: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
