import 'package:flutter/material.dart';
import '../presentation/password_reset_screen/password_reset_screen.dart';
import '../presentation/appointment_booking_screen/appointment_booking_screen.dart';
import '../presentation/service_management_screen/service_management_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/admin_dashboard/admin_dashboard.dart';
import '../presentation/client_dashboard/client_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String passwordReset = '/password-reset-screen';
  static const String appointmentBooking = '/appointment-booking-screen';
  static const String serviceManagement = '/service-management-screen';
  static const String registration = '/registration-screen';
  static const String adminDashboard = '/admin-dashboard';
  static const String clientDashboard = '/client-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const PasswordResetScreen(),
    passwordReset: (context) => const PasswordResetScreen(),
    appointmentBooking: (context) => const AppointmentBookingScreen(),
    serviceManagement: (context) => const ServiceManagementScreen(),
    registration: (context) => const RegistrationScreen(),
    adminDashboard: (context) => const AdminDashboard(),
    clientDashboard: (context) => const ClientDashboard(),
    // TODO: Add your other routes here
  };
}
