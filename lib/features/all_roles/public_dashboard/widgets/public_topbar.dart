// lib/features/all_roles/public_dashboard/widgets/public_topbar.dart

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../features/auth/provider/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';


class PublicTopBar extends StatelessWidget {
  const PublicTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email = authProvider.email ?? 'user@example.com';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingL,
        vertical: AppSizes.paddingM / 2,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            /// 🖼️ App Logo + Title
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/zillha_parishad_logo.jpg', // Replace with your logo
                    height: 48,
                    width: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: AppSizes.spacingM),
                Text(
                  "Zilla Parishad Sangli Public Dashboard".tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: AppFonts.semiBold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),


            const SizedBox(width: AppSizes.spacingL),



            const Spacer(),

            /// 🌐 Language Selector
            _buildLanguageSelector(context),

            const SizedBox(width: AppSizes.spacingM),

            /// 🔔 Notifications
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
              ),
            ),
            /// 🔍 Smaller Search Box
            SizedBox(
              width: 250,
              child: _buildSearchBox(),
            ),

            const SizedBox(width: AppSizes.spacingS),

            /// 👤 Profile Avatar
            GestureDetector(
              onTap: () => _showProfileDialog(context, authProvider, email),
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/images/applogo.jpg'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Search Box inside orange card
  Widget _buildSearchBox() {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white70),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
                fontWeight: AppFonts.regular,
              ),
              decoration: InputDecoration.collapsed(
                hintText: 'Search here',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: AppFonts.regular,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Language Dropdown
  Widget _buildLanguageSelector(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<Locale>(
        value: context.locale,
        dropdownColor: AppColors.primary,
        icon: const Icon(Icons.language, color: Colors.white),
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: AppFonts.medium,
          color: Colors.white,
        ),
        items: const [
          DropdownMenuItem(
            value: Locale('en'),
            child: Text('English 🇬🇧'),
          ),
          DropdownMenuItem(
            value: Locale('mr'),
            child: Text('मराठी 🇮🇳'),
          ),
        ],
        onChanged: (Locale? locale) {
          if (locale != null) context.setLocale(locale);
        },
      ),
    );
  }

  /// 🔹 Profile Dialog
  void _showProfileDialog(BuildContext context, AuthProvider authProvider, String email) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset topRight = button.localToGlobal(
      Offset(button.size.width, 0),
      ancestor: overlay,
    );

    final RelativeRect position = RelativeRect.fromLTRB(
      topRight.dx - 200,
      topRight.dy + button.size.height,
      16,
      0,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          enabled: false,
          child: Row(
            children: [
              const Icon(Icons.email_outlined, color: AppColors.primary),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  email,
                  style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            Future.delayed(const Duration(milliseconds: 0), () => authProvider.logout());
          },
          child: Row(
            children: const [
              Icon(Icons.logout_rounded, color: AppColors.error),
              SizedBox(width: 8),
              Text("Logout", style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
