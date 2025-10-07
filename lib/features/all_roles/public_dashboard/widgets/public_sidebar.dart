import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../core/local_provider/local_provider.dart';
import '../../../auth/provider/auth_provider.dart';

class PublicSidebar extends StatelessWidget {
  final bool minimal;
  final String? selected;
  final Function(String)? onItemSelected;

  const PublicSidebar({
    super.key,
    this.minimal = false,
    this.selected,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final email = authProvider.email ?? 'user@example.com'; // 🔹 Get logged-in email

    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return Container(
          width: minimal ? 90 : 270,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF3B1D9A),
                Color(0xFF5E35B1),
                Color(0xFF7E57C2),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // 🔹 Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Row(
                  mainAxisAlignment: minimal
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(
                        "assets/images/applogo.jpg",
                        height: 42,
                        width: 42,
                        fit: BoxFit.contain,
                      ),
                    ),
                    if (!minimal) ...[
                      const SizedBox(width: 12),

        Flexible(
                        child: Text(
                          email,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const Divider(color: Colors.white24, thickness: 1),

              // 🔹 Menu Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.dashboard,
                      label: "dashboard".tr(),
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.stacked_bar_chart,
                      label: "reports".tr(),
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.house_siding_sharp,
                      label: "departments".tr(),
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.local_fire_department,
                      label: "panchayatSamiti".tr(),
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.schema,
                      label: "schemes".tr(),
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.notification_add,
                      label: "notifications".tr(),
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.settings,
                      label: "settings".tr(),
                    ),
                  ],
                ),
              ),

              // 🔹 Footer
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.white24)),
                ),
                child: Column(
                  children: [
                    if (!minimal)
                      Text(
                        "Powered by\nZP Sangli Smart Portal",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    const SizedBox(height: 10),

                    // 🌐 Language Toggle
                    InkWell(
                      onTap: () {
                        final newLocale =
                        localeProvider.locale.languageCode == 'en'
                            ? const Locale('mr')
                            : const Locale('en');

                        localeProvider.setLocale(newLocale);
                        context.setLocale(newLocale);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: Text(
                          localeProvider.locale.languageCode == 'en'
                              ? "मराठी"
                              : "English",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🔹 Sidebar Menu Item Builder
  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String label,
      }) {
    final bool isActive = selected == label;

    return InkWell(
      onTap: () => onItemSelected?.call(label),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: minimal ? 0 : 14,
        ),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment:
          minimal ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white70,
              size: 22,
            ),
            if (!minimal) ...[
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.white70,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
