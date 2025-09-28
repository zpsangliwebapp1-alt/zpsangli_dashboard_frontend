import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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

    return Container(
      width: sidebarWidth,
      color: Colors.white,
      child: Column(
        crossAxisAlignment:
        minimal ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          // 🔹 Logo + CEO Profile Name Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: isDesktop ? AppSizes.logoSize / 2 : 28,
                  backgroundImage:
                  const AssetImage("assets/images/sangli_zp_logo.png"),
                ),
                const SizedBox(height: 8),
                if (!minimal)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "ceo".tr(),
                        style: AppTextStyles.bodySmall(context).copyWith(
                          fontWeight: AppFonts.semiBold,
                          color: Colors.orange.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (minimal)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "ceo".tr(),
                      style: AppTextStyles.body(context).copyWith(
                        fontWeight: AppFonts.semiBold,
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 🔹 Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: minimal ? 0 : AppSizes.spacing / 2, vertical: 4),
              children: [
                _buildNavItem(Icons.dashboard_outlined, "dashboard".tr(), 0,
                    context, minimal),
                _buildNavItem(Icons.account_tree_outlined, "departments".tr(),
                    1, context, minimal),
                _buildNavItem(Icons.apartment_outlined, "panchayatSamiti".tr(),
                    2, context, minimal),
                _buildNavItem(Icons.people_outline, "gramVikasAdhikari".tr(),
                    3, context, minimal),
                _buildNavItem(Icons.bar_chart_outlined, "reports".tr(), 4,
                    context, minimal),
                _buildNavItem(Icons.account_balance_wallet_outlined, "finance".tr(),
                    5, context, minimal),
                _buildNavItem(Icons.notifications_outlined, "notifications".tr(),
                    6, context, minimal),

                // ✅ Add Meetings
                _buildNavItem(Icons.meeting_room_outlined, "meetings".tr(), 7,
                    context, minimal),

                // ✅ Add Events
                _buildNavItem(Icons.event_outlined, "events".tr(), 8,
                    context, minimal),

                if (!minimal)
                  const SizedBox(height: 12),
                if (!minimal)
                  _UrgentAlertBox(
                    title: "Flood Situation",
                    message: "Kadegaon is under red alert.",
                  ),
              ],
            ),
          ),


          Divider(height: 1, thickness: 0.6, color: Colors.grey.shade300),

          // 🔹 Bottom Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

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
                            Icon(Icons.logout, color: Colors.red.shade600, size: AppSizes.iconSize),
                            const SizedBox(width: 8),
                            Text(
                              "logout".tr(),
                              style: AppTextStyles.bodySmall(context)
                                  .copyWith(color: Colors.red.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Settings Icon only
                Tooltip(
                  message: "settings".tr(),
                  child: InkWell(
                    onTap: () => onItemSelected?.call(7),
                    borderRadius: BorderRadius.circular(12),
                    hoverColor: AppColors.primary.withOpacity(0.05),
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
                        size: AppSizes.iconSize,
                        color: selectedIndex == 7
                            ? AppColors.primary
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),

                // Logout Icon + Label

              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index,
      BuildContext context, bool minimal,
      {bool isDestructive = false}) {
    final isActive = index == selectedIndex;
    final baseColor = isDestructive
        ? Colors.red.shade600
        : isActive
        ? AppColors.primary
        : Colors.grey.shade700;

    final textStyle = AppTextStyles.bodySmall(context).copyWith(
      fontWeight: isActive ? AppFonts.semiBold : AppFonts.regular,
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
              horizontal: minimal ? 0 : AppSizes.padding, vertical: 12),
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
                const SizedBox(width: AppSizes.spacing),
                Flexible(
                    child: Text(label,
                        style: textStyle, overflow: TextOverflow.ellipsis)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


// Keep _UrgentAlertBox as-is




class _UrgentAlertBox extends StatelessWidget {
  final String title;
  final String message;

  const _UrgentAlertBox({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacing / 2),
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
                // 🔹 Title
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.bodySmall(context).copyWith(
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

                // 🔹 Message
                Text(
                  message,
                  style: AppTextStyles.bodySmall(context).copyWith(
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

