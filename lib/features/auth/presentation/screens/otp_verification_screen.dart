import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/constants/app_constants.dart';
import 'package:mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'dart:async';

import 'package:mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:mobile/features/home/presentation/screens/home_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  bool _isLoading = false;
  int _resendTimer = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else {
            setState(() {
              _isLoading = false;
            });
          }

          if (state is AuthenticatedState) {
            // Clear timers
            _timer?.cancel();

            if (state.isNewUser || !state.user.profileCompleted) {
              // Navigate to farmer profile creation
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const FarmerProfileScreen(),
                ),
              );
            } else {
              // Navigate to home screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeTab()),
              );
            }
          } else if (state is AuthErrorState) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is AuthOtpSentState) {
            // OTP resent successfully
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('OTP पुनः भेजा गया'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            _startResendTimer();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppConstants.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          Icons.sms_outlined,
                          size: 40,
                          color: AppConstants.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'OTP सत्यापन',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.phoneNumber} पर भेजा गया OTP दर्ज करें',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // OTP Input fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 45,
                      height: 60,
                      child: TextFormField(
                        controller: _otpControllers[index],
                        focusNode: _otpFocusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppConstants.primaryGreen,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            // Move to next field
                            if (index < 5) {
                              _otpFocusNodes[index + 1].requestFocus();
                            } else {
                              // Last field, try to verify
                              _verifyOTP();
                            }
                          } else {
                            // Move to previous field
                            if (index > 0) {
                              _otpFocusNodes[index - 1].requestFocus();
                            }
                          }
                        },
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 40),

                // Verify button
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'सत्यापित करें',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),

                const SizedBox(height: 32),

                // Resend OTP
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'OTP प्राप्त नहीं हुआ?',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      if (_canResend)
                        TextButton(
                          onPressed: _resendOTP,
                          child: Text(
                            'पुनः भेजें',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.primaryGreen,
                            ),
                          ),
                        )
                      else
                        Text(
                          'पुनः भेजें ($_resendTimer सेकंड में)',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Help text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.amber.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'समस्या आ रही है? कृपया अपना नेटवर्क कनेक्शन जांचें',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _verifyOTP() {
    final otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length == 6) {
      // Verify OTP using BLoC
      context.read<AuthBloc>().add(AuthVerifyOTPEvent(widget.phoneNumber, otp));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('कृपया पूरा OTP दर्ज करें'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _resendOTP() {
    if (_canResend) {
      // Clear current OTP
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _otpFocusNodes[0].requestFocus();

      // Resend OTP
      context.read<AuthBloc>().add(AuthSendOTPEvent(widget.phoneNumber));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}

class FarmerProfileScreen extends StatelessWidget {
  const FarmerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('फार्मर प्रोफ़ाइल'),
        backgroundColor: AppConstants.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'यहां फार्मर प्रोफ़ाइल बनाएँ',
          style: TextStyle(fontSize: 24, color: AppConstants.textPrimary),
        ),
      ),
    );
  }
}
