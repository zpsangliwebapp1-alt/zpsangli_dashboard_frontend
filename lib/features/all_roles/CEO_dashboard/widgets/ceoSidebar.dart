import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class CeoSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;

  const CeoSidebar({
    super.key,
    this.selectedIndex = 0,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Responsive flags
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1024;
    final bool isDesktop = width >= 1024;

    final double sidebarWidth = isDesktop
        ? AppSizes.sidebarWidth
        : isTablet
        ? AppSizes.sidebarMinWidth + 20
        : AppSizes.sidebarMinWidth;

    final bool minimal = !isDesktop;

    // --- Text Sizes (all Poppins) ---
    final logoFontSize   = isDesktop ? 19.0 : isTablet ? 16.0 : 14.0;
    final navFontSize    = isDesktop ? 16.0 : isTablet ? 15.0 : 14.0;
    final urgentTitle    = isDesktop ? 15.0 : 14.0;
    final urgentMessage  = isDesktop ? 14.0 : 13.0;
    final logoutFontSize = isDesktop ? 16.0 : 14.0;
    final bottomIconSize = isDesktop ? 24.0 : 22.0;

    return Container(
      width: sidebarWidth,
      color: AppColors.cardBackground, // Clean white or use AppColors.background if you want modern off-white
      child: Column(
        crossAxisAlignment:
        minimal ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          // Logo section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: isDesktop ? AppSizes.logoSize / 2 : 28,
                  backgroundImage: const AssetImage("assets/images/sangli_zp_logo.png"),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "ceo".tr(),
                    style: GoogleFonts.poppins(
                      fontSize: logoFontSize,
                      fontWeight: AppFonts.semiBold,
                      color: minimal ? Colors.black87 : Colors.orange.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: minimal ? 0 : AppSizes.spacingS / 2, vertical: 4),
              children: [
                _buildNavItem(
                  icon: Icons.dashboard_outlined,
                  label: "dashboard".tr(),
                  index: 0,
                  context: context,
                  minimal: minimal,
                  fontSize: navFontSize,
                ),
                _buildNavItem(
                  icon: Icons.person_add_outlined, // Changed
                  label: "createAccount".tr(),     // Changed
                  index: 1,
                  context: context,
                  minimal: minimal,
                  fontSize: navFontSize,
                ),
                _buildNavItem(
                  icon: Icons.account_tree_outlined,
                  label: "departments".tr(),
                  index: 2,
                  context: context,
                  minimal: minimal,
                  fontSize: navFontSize,
                ),
                _buildNavItem(
                  icon: Icons.apartment_outlined,
                  label: "panchayatSamiti".tr(),
                  index: 3,
                  context: context,
                  minimal: minimal,
                  fontSize: navFontSize,
                ),
                _buildNavItem(
                  icon: Icons.person_add_outlined, // Changed
                  label: "createAccount".tr(),     // Changed
                  index: 3,
                  context: context,
                  minimal: minimal,
                  fontSize: navFontSize,
                ),
                _buildNavItem(
                  icon: Icons.bar_chart_outlined,
                  label: "reports".tr(),
                  index: 4,
                  context: context,
                  minimal: minimal,
                  fontSize: navFontSize,
                ),
                _buildNavItem(
                  icon: Icons.account_balance_wallet_outlined,
                  label: "finance".tr(),
                  index: 5,
                  context: context,
                  minimal: minimal,
                  fontSize: navFontSize,
                ),
                _buildNavItem(
                  icon: Icons.notifications_outlined,
                  label: "notifications".tr(),
                  index: 6,
                  context: context,
                  minimal: minimal,
                  fontSize: navFontSize,
                ),
                _buildNavItem(
                  icon: Icons.meeting_room_outlined,
                  label: "meetings".tr(),
                  index: 7,
                  context: context,
                  minimal: minimal,
                  fontSize: navFontSize,
                ),
                _buildNavItem(
                  icon: Icons.event_outlined,
                  label: "events".tr(),
                  index: 8,
                  context: context,
                  minimal: minimal,
                  fontSize: navFontSize,
                ),
                if (!minimal) ...[
                  const SizedBox(height: 12),
                  _UrgentAlertBox(
                    title: "Flood Situation",
                    message: "Kadegaon is under red alert.",
                    titleFontSize: urgentTitle,
                    messageFontSize: urgentMessage,
                  ),
                ],
              ],
            ),
          ),

          Divider(height: 1, thickness: 0.6, color: Colors.grey.shade300),

          // Bottom Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logout button
                Expanded(
                  child: Tooltip(
                    message: "logout".tr(),
                    child: InkWell(
                      onTap: () => onItemSelected?.call(8),
                      borderRadius: BorderRadius.circular(12),
                      hoverColor: Colors.red.withOpacity(0.1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedIndex == 8
                              ? Colors.red.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, color: Colors.red.shade600, size: bottomIconSize),
                            const SizedBox(width: 8),
                            Text(
                              "logout".tr(),
                              style: GoogleFonts.poppins(
                                fontSize: logoutFontSize,
                                fontWeight: AppFonts.semiBold,
                                color: Colors.red.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Settings Icon
                Tooltip(
                  message: "settings".tr(),
                  child: InkWell(
                    onTap: () => onItemSelected?.call(7),
                    borderRadius: BorderRadius.circular(12),
                    hoverColor: AppColors.primary.withOpacity(0.06),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selectedIndex == 7
                            ? AppColors.primary.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.settings,
                        size: bottomIconSize,
                        color: selectedIndex == 7
                            ? AppColors.primary
                            : Colors.grey.shade700,
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
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required BuildContext context,
    required bool minimal,
    required double fontSize,
    bool isDestructive = false,
  }) {
    final isActive = index == selectedIndex;
    final baseColor = isDestructive
        ? Colors.red.shade600
        : isActive
        ? AppColors.primary
        : Colors.grey.shade700;

    final textStyle = GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: isActive ? AppFonts.semiBold : AppFonts.medium,
      color: baseColor,
    );

    return Tooltip(
      message: minimal ? label : "",
      child: InkWell(
        onTap: () => onItemSelected?.call(index),
        borderRadius: BorderRadius.circular(12),
        hoverColor: AppColors.primary.withOpacity(0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.symmetric(
            horizontal: minimal ? 0 : AppSizes.paddingS,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment:
            minimal ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(icon, size: AppSizes.iconSize, color: baseColor),
              if (!minimal) ...[
                SizedBox(width: AppSizes.spacingS),
                Flexible(child: Text(label, style: textStyle, overflow: TextOverflow.ellipsis)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Alert Box with adjustable font sizes
class _UrgentAlertBox extends StatelessWidget {
  final String title;
  final String message;
  final double titleFontSize;
  final double messageFontSize;

  const _UrgentAlertBox({
    required this.title,
    required this.message,
    this.titleFontSize = 15,
    this.messageFontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.spacingS / 2),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange.shade200, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded,
              color: Colors.orange.shade600, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: titleFontSize,
                          fontWeight: AppFonts.semiBold,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                    Icon(Icons.error_outline,
                        color: Colors.orange.shade600, size: 18),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: messageFontSize,
                    fontWeight: AppFonts.regular,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
