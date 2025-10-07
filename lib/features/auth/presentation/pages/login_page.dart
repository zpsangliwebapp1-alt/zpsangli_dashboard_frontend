import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/role_ids.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../provider/auth_provider.dart';
import '../../../all_roles/BDO_dashboard/presentation/bdo_dashboard_page.dart';
import '../../../all_roles/CEO_dashboard/presentation/ceo_dashboard_page.dart';
import '../../../all_roles/ekatmik_balvikas_yojna_dashboard/presentation/ekatmik_balvikas_yojna_dashboard_page.dart';

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
              constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
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

class _LoginForm extends StatefulWidget {
  const _LoginForm({super.key});

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _navigateByRole(int? roleId) {
    Widget page;
    switch (roleId) {
      case RoleIds.ceo:
        page = const CeoDashboardPage();
        break;
      case RoleIds.bdo:
        page = const BdoHomeLayout();
        break;
      case RoleIds.department:
      case RoleIds.departmentUser:
      case RoleIds.additionalCeo:
      case RoleIds.publicUser:
        page = const EkatmikBalvikasYojnaDashboardPage();
        break;
      default:
        page = const LoginPage();
    }


    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Language Dropdown
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: DropdownButton<Locale>(
                  value: context.locale,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.language, color: Colors.white),
                  dropdownColor: Colors.black87,
                  items: const [
                    DropdownMenuItem(value: Locale('en'), child: Text('English', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: Locale('mr'), child: Text('मराठी', style: TextStyle(color: Colors.white))),
                  ],
                  onChanged: (locale) {
                    if (locale != null) context.setLocale(locale);
                  },
                ),
              ),
            ),

            ClipOval(
              child: _safeImage(AppStrings.zpLogo, height: 120, width: 120, fit: BoxFit.fill),
            ),
            const SizedBox(height: 20),
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

            _buildTextField(hint: 'emailMobile'.tr(), icon: Icons.email_outlined, controller: emailController),
            const SizedBox(height: 16),
            _buildTextField(hint: 'password'.tr(), icon: Icons.lock_outline, controller: passwordController, isPassword: true),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return ElevatedButton(
                    onPressed: auth.loading
                        ? null
                        : () async {
                      final success = await auth.login(emailController.text.trim(), passwordController.text.trim());
                      if (!mounted) return;

                      if (success) {
                        _navigateByRole(auth.roleId);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid credentials')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: auth.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('login'.tr(), style: AppTextStyles.button(context)?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return SizedBox(
      width: 330,
      child: TextField(
        controller: controller,
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

Widget _safeImage(String assetPath, {double? height, double? width, BoxFit? fit}) {
  return Image.asset(
    assetPath,
    height: height,
    width: width,
    fit: fit,
    errorBuilder: (context, error, stackTrace) {
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


