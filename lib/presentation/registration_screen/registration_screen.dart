import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/email_verification_modal_widget.dart';
import './widgets/registration_form_widget.dart';
import './widgets/terms_acceptance_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isTermsAccepted = false;
  bool _isLoading = false;
  bool _isFormValid = false;

  // Mock API data
  final List<Map<String, dynamic>> existingUsers = [
    {
      "id": 1,
      "email": "admin@candysoftsalon.com",
      "fullName": "María González",
      "phone": "+34 612 345 678",
      "role": "administrador",
      "isVerified": true,
    },
    {
      "id": 2,
      "email": "cliente@ejemplo.com",
      "fullName": "Ana Rodríguez",
      "phone": "+34 687 654 321",
      "role": "cliente",
      "isVerified": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _addFormListeners();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _addFormListeners() {
    _fullNameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    final hasRequiredFields = _fullNameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _isTermsAccepted;

    if (_isFormValid != (isValid && hasRequiredFields)) {
      setState(() {
        _isFormValid = isValid && hasRequiredFields;
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _onTermsChanged(bool? value) {
    setState(() {
      _isTermsAccepted = value ?? false;
    });
    _validateForm();
  }

  void _onPasswordChanged(String value) {
    setState(() {
      // Trigger rebuild for password strength indicator
    });
    _validateForm();
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate() || !_isTermsAccepted) {
      _showErrorMessage(
          'Por favor, complete todos los campos correctamente y acepte los términos.');
      return;
    }

    // Check if email already exists
    final emailExists = (existingUsers as List).any(
      (dynamic user) =>
          (user as Map<String, dynamic>)["email"] ==
          _emailController.text.trim().toLowerCase(),
    );

    if (emailExists) {
      _showErrorMessage(
          'Este correo electrónico ya está registrado. Intente con otro correo.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API registration call
      await Future.delayed(const Duration(seconds: 3));

      // Simulate successful registration
      final newUser = {
        "id": existingUsers.length + 1,
        "email": _emailController.text.trim().toLowerCase(),
        "fullName": _fullNameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "role": "cliente",
        "isVerified": false,
        "registrationDate": DateTime.now().toIso8601String(),
      };

      existingUsers.add(newUser);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show email verification modal
        _showEmailVerificationModal();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorMessage(
            'Error de conexión. Por favor, verifique su conexión a internet e intente nuevamente.');
      }
    }
  }

  void _showEmailVerificationModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return EmailVerificationModalWidget(
          email: _emailController.text.trim(),
          onResendEmail: _handleResendVerificationEmail,
          onContinueToVerification: _navigateToVerification,
        );
      },
    );
  }

  void _handleResendVerificationEmail() {
    // Handle resend logic (already implemented in modal)
  }

  void _navigateToVerification() {
    Navigator.of(context).pop(); // Close modal
    // Navigate to email verification screen
    _showSuccessMessage(
        'Registro completado. Revise su correo para verificar su cuenta.');

    // For demo purposes, navigate to client dashboard after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/client-dashboard');
      }
    });
  }

  void _showErrorMessage(String message) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'error_outline',
              color: AppTheme.lightTheme.colorScheme.onError,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onError,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.w),
        ),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle_outline',
              color: AppTheme.lightTheme.colorScheme.onInverseSurface,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onInverseSurface,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF27AE60),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.w),
        ),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pop(context);
  }

  void _navigateToPasswordReset() {
    Navigator.pushNamed(context, '/password-reset-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _navigateToLogin,
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 6.w,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 10.w,
                      minHeight: 6.h,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Crear Cuenta',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.h),

                    // Logo and Welcome
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 25.w,
                            height: 25.w,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.lightTheme.colorScheme.primary,
                                  AppTheme.lightTheme.colorScheme.secondary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'content_cut',
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                size: 12.w,
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'CandySoft Salon',
                            style: AppTheme.lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Únete a nuestra comunidad de belleza',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Registration Form
                    RegistrationFormWidget(
                      formKey: _formKey,
                      fullNameController: _fullNameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      isPasswordVisible: _isPasswordVisible,
                      isConfirmPasswordVisible: _isConfirmPasswordVisible,
                      onPasswordVisibilityToggle: _togglePasswordVisibility,
                      onConfirmPasswordVisibilityToggle:
                          _toggleConfirmPasswordVisibility,
                      onPasswordChanged: _onPasswordChanged,
                    ),
                    SizedBox(height: 3.h),

                    // Terms Acceptance
                    TermsAcceptanceWidget(
                      isTermsAccepted: _isTermsAccepted,
                      onTermsChanged: _onTermsChanged,
                    ),
                    SizedBox(height: 4.h),

                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isFormValid && !_isLoading
                            ? _handleRegistration
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                          elevation: _isFormValid ? 2 : 0,
                        ),
                        child: _isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 5.w,
                                    height: 5.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    'Creando cuenta...',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelLarge
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                'Crear Cuenta',
                                style: AppTheme.lightTheme.textTheme.labelLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Login Link
                    Center(
                      child: TextButton(
                        onPressed: _navigateToLogin,
                        child: RichText(
                          text: TextSpan(
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                            children: [
                              const TextSpan(
                                text: '¿Ya tienes una cuenta? ',
                              ),
                              TextSpan(
                                text: 'Iniciar Sesión',
                                style: TextStyle(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Password Reset Link
                    Center(
                      child: TextButton(
                        onPressed: _navigateToPasswordReset,
                        child: Text(
                          '¿Olvidaste tu contraseña?',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
