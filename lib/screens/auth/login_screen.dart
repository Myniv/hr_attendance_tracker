import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/providers/auth_provider.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:hr_attendance_tracker/routes.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CustomTheme _customTheme = CustomTheme();
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
            height:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 80,
                      width: 80,
                    ),

                    const SizedBox(height: 32),

                    Text(
                      "Welcome Back",
                      style: _customTheme.superLargeFont(
                        CustomTheme.colorGold,
                        FontWeight.w700,
                        context,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Sign in to your account",
                      style: _customTheme.smallFont(
                        CustomTheme.whiteButNot.withOpacity(0.8),
                        FontWeight.w400,
                        context,
                      ),
                    ),

                    const SizedBox(height: 40),

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
                            return "Please enter your password";
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
                      child: authProvider.isLoading
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
                              icon: const Icon(Icons.email_rounded, size: 20),
                              label: Text('Sign In with Email'),
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

                                final email = _emailController.text.trim();
                                final password = _passwordController.text
                                    .trim();

                                final success = await authProvider
                                    .signInWithEmail(
                                      email,
                                      password,
                                      profileProvider,
                                    );

                                if (success && mounted) {
                                  //AuthWrapper auto redirect
                                }
                              },
                            ),
                    ),

                    const SizedBox(height: 16),

                    // SizedBox(
                    //   width: double.infinity,
                    //   child: OutlinedButton.icon(
                    //     icon: Image.asset(
                    //       "assets/images/google_logo.png",
                    //       height: 20,
                    //     ),
                    //     label: Text('Sign In with Google'),
                    //     style: OutlinedButton.styleFrom(
                    //       foregroundColor: CustomTheme.whiteButNot,
                    //       side: BorderSide(
                    //         color: CustomTheme.colorGold,
                    //         width: 2,
                    //       ),
                    //       padding: const EdgeInsets.symmetric(vertical: 18),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: CustomTheme.borderRadius,
                    //       ),
                    //       textStyle: _customTheme.mediumFont(
                    //         CustomTheme.whiteButNot,
                    //         FontWeight.w600,
                    //         context,
                    //       ),
                    //     ),
                    //     onPressed: () async {
                    //       final success = await authProvider.signInWithGoogle(
                    //         profileProvider,
                    //       );

                    //       if (success && mounted) {
                    //         //AuthWrapper auto redirect
                    //       } else if (mounted) {
                    //         _customTheme.customScaffoldMessage(
                    //           context: context,
                    //           message:
                    //               authProvider.errorMessage ??
                    //               "Google Sign-In failed",
                    //           backgroundColor: Colors.red,
                    //         );
                    //       }
                    //     },
                    //   ),
                    // ),

                    // const SizedBox(height: 40),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       "Don't have an account? ",
                    //       style: _customTheme.smallFont(
                    //         CustomTheme.whiteButNot.withOpacity(0.8),
                    //         FontWeight.w400,
                    //         context,
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.pushNamed(context, AppRoutes.register);
                    //       },
                    //       child: Text(
                    //         "Sign Up",
                    //         style: _customTheme.smallFont(
                    //           CustomTheme.colorGold,
                    //           FontWeight.w700,
                    //           context,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    // const SizedBox(height: 20),
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
