import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/local_provider/local_provider.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../routing/route_names.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: const _LoginMobile(),
      tablet: const _LoginDesktop(),
      desktop: const _LoginDesktop(),
    );
  }
}

/// ---------------- MOBILE ----------------
class _LoginMobile extends StatelessWidget {
  const _LoginMobile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _safeImage(AppStrings.mobilelogin_page_image, fit: BoxFit.fill),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: const _LoginForm(),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------- TABLET ----------------
class _LoginTablet extends StatelessWidget {
  const _LoginTablet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          const Expanded(flex: 5, child: _LoginForm()),
          Expanded(
            flex: 5,
            child: _safeImage(AppStrings.login_page_image, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}

/// ---------------- DESKTOP ----------------
class _LoginDesktop extends StatelessWidget {
  const _LoginDesktop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _safeImage(AppStrings.login_page_image, fit: BoxFit.cover),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 480,
                maxHeight: 600,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15), // transparent
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: const _LoginForm(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------- LOGIN FORM ----------------
class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Language Dropdown (top-right)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: DropdownButton<Locale>(
                  value: context.locale,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.language, color: Colors.white),
                  dropdownColor: Colors.black87, // Optional: dropdown background
                  items: [
                    DropdownMenuItem(
                      value: const Locale('en'),
                      child: Text(
                        'English',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: const Locale('mr'),
                      child: Text(
                        'मराठी',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  onChanged: (Locale? locale) {
                    if (locale != null) {
                      context.setLocale(locale); // updates all .tr() texts instantly
                    }
                  },
                ),
              ),
            ),


            // 🔹 Logo
            ClipOval(
              child: _safeImage(
                AppStrings.zpLogo,
                height: 120,
                width: 120,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Welcome Texts
            Text(
              'welcomeBack'.tr(),
              style: AppTextStyles.headline1(context)?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'panchayatDashboard'.tr(),
              style: AppTextStyles.body(context)?.copyWith(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 28),

            // 🔹 Email Field
            _buildTextField(
              context,
              hint: 'emailMobile'.tr(),
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),

            // 🔹 Password Field
            _buildTextField(
              context,
              hint: 'password'.tr(),
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 28),

            // 🔹 Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteNames.ceo_dashboard);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'login'.tr(),
                  style: AppTextStyles.button(context)?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context,
      {required String hint, required IconData icon, bool isPassword = false}) {
    return SizedBox(
      width: 330,
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.redAccent),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
        ),
      ),
    );
  }
}

/// ---------------- SAFE IMAGE WIDGET ----------------
Widget _safeImage(
    String assetPath, {
      double? height,
      double? width,
      BoxFit? fit,
    }) {
  return Image.asset(
    assetPath,
    height: height,
    width: width,
    fit: fit,
    errorBuilder: (context, error, stackTrace) {
      // Fallback if asset not found
      return Container(
        height: height,
        width: width,
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image, size: 40, color: Colors.red),
      );
    },
  );
}
