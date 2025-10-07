import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/local_provider/local_provider.dart';

class AdditionalCeoTopBar extends StatelessWidget {
  const AdditionalCeoTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 1024;
    final bool isTablet = width >= 600 && width < 1024;

    final double logoSize = isDesktop ? 60 : (isTablet ? 50 : 40);
    final double avatarRadius = isDesktop ? 20 : 16;
    final double spacing = 16.0;

    return Container(
      color: Colors.orange,
      padding: EdgeInsets.symmetric(horizontal: spacing, vertical: 12),
      child: Row(
        children: [
          // Logo + Title
          Row(
            children: [
              Container(
                height: logoSize,
                width: logoSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/zillha_parishad_logo.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: spacing),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "zillaParishadSangliDashboard".tr(),
                    style: AppTextStyles.headline2(context).copyWith(
                      fontWeight: AppFonts.bold,
                      fontSize: isDesktop ? 22 : 18,
                      color: const Color(0xFFE0F3FF), // Deep Blue
                    ),
                  ),
                  Text(
                    "Government of India",
                    style: AppTextStyles.body(context).copyWith(
                      fontWeight: AppFonts.semiBold,
                      fontSize: isDesktop ? 14 : 12,
                      color: const Color(0xFFEEF2F5), // Grey for subtitle
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),

          // Search box (Desktop only)
          // Search box (Desktop only)
          if (isDesktop)
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: spacing),
                decoration: BoxDecoration(
                  color: Colors.white, // clean base
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Focus(
                  onFocusChange: (hasFocus) {
                    // optionally, trigger UI changes on focus
                  },
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF111827),
                    ),
                    decoration: InputDecoration(
                      hintText: 'searchHere'.tr(),
                      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF1E3A8A),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                    ),
                  ),
                ),
              ),
            ),

          // Language Selector (Desktop)
          if (isDesktop) SizedBox(width: spacing * 1.5),
          if (isDesktop)
            Consumer<LocaleProvider>(
              builder: (context, localeProvider, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    // color: const Color(0xFFF3F4F6), // Soft grey background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Locale>(
                      value: context.locale,
                      dropdownColor: const Color(0xFF1E3A8A), // Deep Blue
                      borderRadius: BorderRadius.circular(12),
                      icon: const Icon(Icons.language, color: Colors.white),
                      items: [
                        DropdownMenuItem(
                          value: const Locale('en'),
                          child: Row(
                            children: [
                              // const Icon(Icons.flag, color: Colors.white, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'english'.tr(),
                                style: AppTextStyles.bodySmall(
                                  context,
                                ).copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: const Locale('mr'),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.translate,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'मराठी'.tr(),
                                style: AppTextStyles.bodySmall(
                                  context,
                                ).copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (Locale? locale) {
                        if (locale != null) context.setLocale(locale);
                      },
                    ),
                  ),
                );
              },
            ),

          SizedBox(width: spacing),
          PopupMenuButton<int>(
            offset: const Offset(0, 50), // position below avatar
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            elevation: 4,
            iconSize: avatarRadius * 2,
            icon: CircleAvatar(
              radius: avatarRadius,
              backgroundImage: const AssetImage(
                "assets/images/login_image.jpg",
              ),
              backgroundColor: const Color(0xFFE5E7EB),
            ),
            itemBuilder: (context) => [
              // Profile Info (non-clickable)
              const PopupMenuItem<int>(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Suraj Shinde",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "ceo@example.com",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              // Logout button
              const PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red, size: 18),
                    SizedBox(width: 8),
                    Text("Logout", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                // Navigate to login page
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
