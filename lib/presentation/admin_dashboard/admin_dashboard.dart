import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/appointment_overview_card.dart';
import './widgets/dashboard_metrics_card.dart';
import './widgets/quick_action_card.dart';
import './widgets/revenue_chart_card.dart';
import './widgets/services_overview_card.dart';
import './widgets/staff_performance_card.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String adminName = "María González";
  String currentDate = "Jueves, 22 de agosto de 2025";

  // Mock data for dashboard
  final List<Map<String, dynamic>> todayAppointments = [
    {
      "id": 1,
      "clientName": "Ana Martínez",
      "services": ["Manicura Clásica", "Pedicura"],
      "time": "09:30",
      "status": "Confirmada",
      "manicurist": "Laura Pérez"
    },
    {
      "id": 2,
      "clientName": "Carmen López",
      "services": ["Uñas Acrílicas"],
      "time": "11:00",
      "status": "Pendiente",
      "manicurist": "Sofia Ruiz"
    },
    {
      "id": 3,
      "clientName": "Isabel García",
      "services": ["Manicura Francesa", "Decoración"],
      "time": "14:30",
      "status": "Confirmada",
      "manicurist": "Laura Pérez"
    },
    {
      "id": 4,
      "clientName": "Lucía Hernández",
      "services": ["Pedicura Spa"],
      "time": "16:00",
      "status": "Confirmada",
      "manicurist": "Sofia Ruiz"
    }
  ];

  final Map<String, dynamic> revenueData = {
    "diario": {
      "total": "2,450",
      "chartData": [1200, 1800, 2100, 1900, 2450, 2200, 2800]
    },
    "semanal": {
      "total": "18,500",
      "chartData": [15000, 16500, 17200, 18500, 19200, 18800, 20100]
    },
    "mensual": {
      "total": "75,200",
      "chartData": [65000, 68000, 72000, 75200, 78000, 76500, 80000]
    }
  };

  final List<Map<String, dynamic>> popularServices = [
    {
      "id": 1,
      "name": "Manicura Clásica",
      "price": "\$25.00",
      "bookings": 45,
      "popularity": 85,
      "image":
          "https://images.pexels.com/photos/3997379/pexels-photo-3997379.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    },
    {
      "id": 2,
      "name": "Uñas Acrílicas",
      "price": "\$45.00",
      "bookings": 32,
      "popularity": 70,
      "image":
          "https://images.pexels.com/photos/3997392/pexels-photo-3997392.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    },
    {
      "id": 3,
      "name": "Pedicura Spa",
      "price": "\$35.00",
      "bookings": 28,
      "popularity": 65,
      "image":
          "https://images.pexels.com/photos/3997386/pexels-photo-3997386.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    },
    {
      "id": 4,
      "name": "Manicura Francesa",
      "price": "\$30.00",
      "bookings": 24,
      "popularity": 55,
      "image":
          "https://images.pexels.com/photos/3997981/pexels-photo-3997981.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    }
  ];

  final List<Map<String, dynamic>> staffPerformance = [
    {
      "id": 1,
      "name": "Laura Pérez",
      "completedAppointments": 28,
      "rating": 4.9,
      "performance": "Excelente",
      "avatar":
          "https://images.pexels.com/photos/3762800/pexels-photo-3762800.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    },
    {
      "id": 2,
      "name": "Sofia Ruiz",
      "completedAppointments": 24,
      "rating": 4.7,
      "performance": "Bueno",
      "avatar":
          "https://images.pexels.com/photos/3762806/pexels-photo-3762806.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    },
    {
      "id": 3,
      "name": "Carmen Vega",
      "completedAppointments": 19,
      "rating": 4.5,
      "performance": "Bueno",
      "avatar":
          "https://images.pexels.com/photos/3762811/pexels-photo-3762811.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshDashboard() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDashboardTab(),
                  _buildServicesTab(),
                  _buildAppointmentsTab(),
                  _buildSettlementsTab(),
                  _buildProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/appointment-booking-screen');
              },
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme
                    .lightTheme.floatingActionButtonTheme.foregroundColor!,
                size: 24,
              ),
              label: Text(
                'Nueva Cita',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme
                      .lightTheme.floatingActionButtonTheme.foregroundColor,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, $adminName',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      currentDate,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Handle notifications
                    },
                    icon: Stack(
                      children: [
                        CustomIconWidget(
                          iconName: 'notifications',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 24,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.error,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle settings
                    },
                    icon: CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: const [
          Tab(text: 'Dashboard'),
          Tab(text: 'Servicios'),
          Tab(text: 'Citas'),
          Tab(text: 'Liquidaciones'),
          Tab(text: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _refreshDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),

            // Metrics Cards Row
            Row(
              children: [
                Expanded(
                  child: DashboardMetricsCard(
                    title: 'Citas Hoy',
                    value: todayAppointments.length.toString(),
                    subtitle: '2 pendientes',
                    iconName: 'event',
                    onTap: () {
                      _tabController.animateTo(2);
                    },
                  ),
                ),
                Expanded(
                  child: DashboardMetricsCard(
                    title: 'Ingresos Hoy',
                    value: '\$2,450',
                    subtitle: '+12% vs ayer',
                    iconName: 'attach_money',
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.05),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: DashboardMetricsCard(
                    title: 'Servicios Activos',
                    value: popularServices.length.toString(),
                    subtitle: 'Todos disponibles',
                    iconName: 'spa',
                    onTap: () {
                      _tabController.animateTo(1);
                    },
                  ),
                ),
                Expanded(
                  child: DashboardMetricsCard(
                    title: 'Liquidaciones',
                    value: '3',
                    subtitle: 'Pendientes',
                    iconName: 'receipt',
                    backgroundColor: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                    onTap: () {
                      _tabController.animateTo(3);
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Quick Actions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Acciones Rápidas',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(height: 1.h),

            QuickActionCard(
              title: 'Agregar Servicio',
              description: 'Crear un nuevo servicio para el salón',
              iconName: 'add_circle',
              onTap: () {
                Navigator.pushNamed(context, '/service-management-screen');
              },
            ),

            QuickActionCard(
              title: 'Ver Horario de Hoy',
              description: 'Revisar todas las citas programadas',
              iconName: 'schedule',
              onTap: () {
                _tabController.animateTo(2);
              },
            ),

            SizedBox(height: 2.h),

            // Revenue Chart
            RevenueChartCard(revenueData: revenueData),

            // Appointments Overview
            AppointmentOverviewCard(
              appointments: todayAppointments,
              onViewAll: () {
                _tabController.animateTo(2);
              },
            ),

            // Services Overview
            ServicesOverviewCard(
              popularServices: popularServices,
              onViewAll: () {
                _tabController.animateTo(1);
              },
            ),

            // Staff Performance
            StaffPerformanceCard(
              staffPerformance: staffPerformance,
              onViewAll: () {
                // Navigate to staff details
              },
            ),

            SizedBox(height: 10.h),
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
            'Gestión de Servicios',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Administra los servicios del salón',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/service-management-screen');
            },
            child: const Text('Ir a Servicios'),
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
            'Gestión de Citas',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Administra las citas del salón',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/appointment-booking-screen');
            },
            child: const Text('Nueva Cita'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'receipt',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Liquidaciones',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Revisa las liquidaciones del personal',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
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
            height: 24.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                adminName.substring(0, 1).toUpperCase(),
                style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            adminName,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Administrador',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: () {
              // Handle logout
              Navigator.pushReplacementNamed(context, '/registration-screen');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
