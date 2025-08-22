import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/code_verification_step.dart';
import './widgets/email_input_step.dart';
import './widgets/new_password_step.dart';
import './widgets/success_dialog.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final PageController _pageController = PageController();

  // Mock API data
  final Map<String, dynamic> mockApiData = {
    "validEmails": [
      "admin@candysoft.com",
      "cliente@candysoft.com",
      "recepcionista@candysoft.com",
      "manicurista@candysoft.com"
    ],
    "validCodes": {
      "admin@candysoft.com": "123456",
      "cliente@candysoft.com": "654321",
      "recepcionista@candysoft.com": "789012",
      "manicurista@candysoft.com": "345678"
    }
  };

  int _currentStep = 0;
  String _currentEmail = '';
  String _currentCode = '';
  bool _isLoading = false;

  // Mock API call for email submission
  Future<bool> _submitEmail(String email) async {
    setState(() => _isLoading = true);

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    final validEmails = mockApiData["validEmails"] as List<String>;
    final isValid = validEmails.contains(email.toLowerCase());

    setState(() => _isLoading = false);

    if (isValid) {
      setState(() => _currentEmail = email);
      return true;
    } else {
      _showErrorToast('Correo electrónico no encontrado en nuestros registros');
      return false;
    }
  }

  // Mock API call for code verification
  Future<bool> _verifyCode(String code) async {
    setState(() => _isLoading = true);

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    final validCodes = mockApiData["validCodes"] as Map<String, String>;
    final expectedCode = validCodes[_currentEmail.toLowerCase()];
    final isValid = code == expectedCode;

    setState(() => _isLoading = false);

    if (isValid) {
      setState(() => _currentCode = code);
      return true;
    } else {
      _showErrorToast('Código de verificación incorrecto');
      return false;
    }
  }

  // Mock API call for password reset
  Future<bool> _resetPassword(String newPassword) async {
    setState(() => _isLoading = true);

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    // Always succeed for demo purposes
    return true;
  }

  // Mock API call for resending code
  Future<bool> _resendCode() async {
    setState(() => _isLoading = true);

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    _showSuccessToast('Código reenviado exitosamente');
    return true;
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.error,
      textColor: AppTheme.lightTheme.colorScheme.onError,
      fontSize: 14.sp,
    );
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: AppTheme.lightTheme.colorScheme.onPrimary,
      fontSize: 14.sp,
    );
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleEmailSubmit(String email) async {
    final success = await _submitEmail(email);
    if (success) {
      _nextStep();
    }
  }

  void _handleCodeVerify(String code) async {
    final success = await _verifyCode(code);
    if (success) {
      _nextStep();
    }
  }

  void _handlePasswordReset(String password) async {
    final success = await _resetPassword(password);
    if (success) {
      _showSuccessDialog();
    } else {
      _showErrorToast(
          'Error al restablecer la contraseña. Inténtalo de nuevo.');
    }
  }

  void _handleResendCode() async {
    await _resendCode();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        onContinue: () {
          Navigator.of(context).pop(); // Close dialog
          Navigator.of(context).pop(); // Return to login
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Row(
                children: List.generate(3, (index) {
                  final isActive = index <= _currentStep;
                  final isCompleted = index < _currentStep;

                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      height: 1.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.5.h),
                        color: isActive
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                      ),
                      child: isCompleted
                          ? Center(
                              child: CustomIconWidget(
                                iconName: 'check',
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                size: 3.w,
                              ),
                            )
                          : null,
                    ),
                  );
                }),
              ),
            ),

            // Step labels
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStepLabel('Email', 0),
                  _buildStepLabel('Código', 1),
                  _buildStepLabel('Contraseña', 2),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 70.h,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: SizedBox(
                    height: 70.h,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // Step 1: Email Input
                        Center(
                          child: EmailInputStep(
                            onEmailSubmit: _handleEmailSubmit,
                            isLoading: _isLoading,
                          ),
                        ),

                        // Step 2: Code Verification
                        Center(
                          child: CodeVerificationStep(
                            email: _currentEmail,
                            onCodeVerify: _handleCodeVerify,
                            onResendCode: _handleResendCode,
                            onBackPressed: _previousStep,
                            isLoading: _isLoading,
                          ),
                        ),

                        // Step 3: New Password
                        Center(
                          child: NewPasswordStep(
                            onPasswordReset: _handlePasswordReset,
                            onBackPressed: _previousStep,
                            isLoading: _isLoading,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepLabel(String label, int stepIndex) {
    final isActive = stepIndex <= _currentStep;

    return Text(
      label,
      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
        color: isActive
            ? AppTheme.lightTheme.colorScheme.primary
            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }
}
