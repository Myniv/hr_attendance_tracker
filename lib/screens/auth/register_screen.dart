import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/providers/auth_provider.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:hr_attendance_tracker/routes.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final CustomTheme _customTheme = CustomTheme();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      backgroundColor: CustomTheme.backgroundScreenColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    Image.asset(
                      "assets/images/logo.png",
                      height: 80,
                      width: 80,
                    ),

                    const SizedBox(height: 32),

                    Text(
                      "Create Account",
                      style: _customTheme.superLargeFont(
                        CustomTheme.colorGold,
                        FontWeight.w700,
                        context,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Join us and get started",
                      style: _customTheme.smallFont(
                        CustomTheme.whiteButNot.withOpacity(0.8),
                        FontWeight.w400,
                        context,
                      ),
                    ),

                    const SizedBox(height: 40),

                    _customTheme.customTextField(
                      context: context,
                      controller: _usernameController,
                      label: "Username",
                      hint: "Enter your username",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a username";
                        }
                        if (value.trim().length < 3) {
                          return "Username must be at least 3 characters";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    _customTheme.customTextField(
                      context: context,
                      controller: _emailController,
                      label: "Email Address",
                      hint: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your email";
                        }
                        if (!RegExp(
                          r'^[^@]+@[^@]+\.[^@]+',
                        ).hasMatch(value.trim())) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: CustomTheme.borderRadius,
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: _customTheme.smallFont(
                          CustomTheme.colorBrown,
                          FontWeight.w500,
                          context,
                        ),
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          labelStyle: _customTheme.superSmallFont(
                            CustomTheme.colorLightBrown,
                            FontWeight.w600,
                            context,
                          ),
                          hintStyle: _customTheme.superSmallFont(
                            CustomTheme.colorLightBrown.withOpacity(0.6),
                            FontWeight.w400,
                            context,
                          ),
                          filled: true,
                          fillColor: CustomTheme.whiteButNot,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: CustomTheme.colorLightBrown,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: CustomTheme.borderRadius,
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a password";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    if (authProvider.errorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red.shade200),
                          borderRadius: CustomTheme.borderRadius,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade600,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                authProvider.errorMessage!,
                                style: _customTheme.smallFont(
                                  Colors.red.shade800,
                                  FontWeight.w500,
                                  context,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(
                      width: double.infinity,
                      child: _isLoading
                          ? Container(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: CustomTheme.colorGold.withOpacity(0.7),
                                borderRadius: CustomTheme.borderRadius,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: CustomTheme.colorBrown,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : ElevatedButton.icon(
                              icon: const Icon(
                                Icons.person_add_rounded,
                                size: 20,
                              ),
                              label: Text('Create Account'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomTheme.colorGold,
                                foregroundColor: CustomTheme.colorBrown,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: CustomTheme.borderRadius,
                                ),
                                elevation: 6,
                                shadowColor: CustomTheme.colorGold.withOpacity(
                                  0.5,
                                ),
                                textStyle: _customTheme.mediumFont(
                                  CustomTheme.colorBrown,
                                  FontWeight.w700,
                                  context,
                                ),
                              ),
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;

                                setState(() => _isLoading = true);
                                try {
                                  final success = await authProvider
                                      .registerWithEmail(
                                        _emailController.text.trim(),
                                        _passwordController.text.trim(),
                                        profileProvider,
                                      );

                                  if (success && mounted) {
                                    _customTheme.customScaffoldMessage(
                                      context: context,
                                      message:
                                          "Registration successful! Please sign in with your credentials.",
                                      backgroundColor: Colors.green,
                                    );

                                    Navigator.pushReplacementNamed(
                                      context,
                                      AppRoutes.login,
                                    );
                                  } else if (mounted) {
                                    _customTheme.customScaffoldMessage(
                                      context: context,
                                      message:
                                          authProvider.errorMessage ??
                                          "Registration failed",
                                      backgroundColor: Colors.red,
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    _customTheme.customScaffoldMessage(
                                      context: context,
                                      message: "Registration failed: $e",
                                      backgroundColor: Colors.red,
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() => _isLoading = false);
                                  }
                                }
                              },
                            ),
                    ),

                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: _customTheme.smallFont(
                            CustomTheme.whiteButNot.withOpacity(0.8),
                            FontWeight.w400,
                            context,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.login,
                            );
                          },
                          child: Text(
                            "Sign In",
                            style: _customTheme.smallFont(
                              CustomTheme.colorGold,
                              FontWeight.w700,
                              context,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
