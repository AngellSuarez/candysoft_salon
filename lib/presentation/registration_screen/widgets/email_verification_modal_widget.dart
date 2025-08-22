import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmailVerificationModalWidget extends StatefulWidget {
  final String email;
  final VoidCallback onResendEmail;
  final VoidCallback onContinueToVerification;

  const EmailVerificationModalWidget({
    super.key,
    required this.email,
    required this.onResendEmail,
    required this.onContinueToVerification,
  });

  @override
  State<EmailVerificationModalWidget> createState() =>
      _EmailVerificationModalWidgetState();
}

class _EmailVerificationModalWidgetState
    extends State<EmailVerificationModalWidget> {
  bool _isResending = false;
  int _resendCooldown = 0;

  void _handleResendEmail() async {
    if (_resendCooldown > 0) return;

    setState(() {
      _isResending = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isResending = false;
        _resendCooldown = 60; // 60 seconds cooldown
      });

      // Start countdown
      _startCooldownTimer();

      widget.onResendEmail();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Correo de verificación reenviado exitosamente',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onInverseSurface,
            ),
          ),
          backgroundColor: const Color(0xFF27AE60),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
        ),
      );
    }
  }

  void _startCooldownTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCooldown > 0) {
        setState(() {
          _resendCooldown--;
        });
        _startCooldownTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4.w),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: const Color(0xFF27AE60).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'mark_email_read',
                  color: const Color(0xFF27AE60),
                  size: 10.w,
                ),
              ),
            ),
            SizedBox(height: 3.h),

            // Title
            Text(
              '¡Registro Exitoso!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),

            // Description
            Text(
              'Hemos enviado un correo de verificación a:',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),

            // Email
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                widget.email,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 2.h),

            // Instructions
            Text(
              'Por favor, revise su bandeja de entrada y haga clic en el enlace de verificación para activar su cuenta.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),

            // Resend Email Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _resendCooldown > 0 || _isResending
                    ? null
                    : _handleResendEmail,
                icon: _isResending
                    ? SizedBox(
                        width: 4.w,
                        height: 4.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      )
                    : CustomIconWidget(
                        iconName: 'refresh',
                        color: _resendCooldown > 0
                            ? AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.4)
                            : AppTheme.lightTheme.colorScheme.primary,
                        size: 4.w,
                      ),
                label: Text(
                  _resendCooldown > 0
                      ? 'Reenviar en ${_resendCooldown}s'
                      : _isResending
                          ? 'Reenviando...'
                          : 'Reenviar Correo',
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.onContinueToVerification,
                icon: CustomIconWidget(
                  iconName: 'arrow_forward',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 4.w,
                ),
                label: const Text('Continuar a Verificación'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
            SizedBox(height: 1.h),

            // Help Text
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to help or contact screen
              },
              child: Text(
                '¿No recibió el correo? Contacte soporte',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
