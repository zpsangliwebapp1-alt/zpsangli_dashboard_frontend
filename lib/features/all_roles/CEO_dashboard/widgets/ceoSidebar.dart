// lib/ui/widgets/zp_ceo_sidebar.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_fonts.dart';

class CeoSidebar extends StatelessWidget {
  final bool minimal;
  final int selectedIndex;          // ✅ add this
  final ValueChanged<int>? onItemSelected; // ✅ add this

  const CeoSidebar({
    super.key,
   this.minimal = false,
    this.selectedIndex = 0,
    required  this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: minimal ? AppSizes.sidebarMinWidth : AppSizes.sidebarWidth,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 0.8),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        minimal ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          // ✅ Logo + Title
          Row(
            mainAxisAlignment:
            minimal ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Container(
                height: AppSizes.logoSize,
                width: AppSizes.logoSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/sangli_zp_logo.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (!minimal) ...[
                const SizedBox(width: AppSizes.spacing),
                Flexible(
                  child: Text(
                    "ceo".tr(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade900,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]
            ],
          ),
          const SizedBox(height: 32),

          // ✅ Navigation Items
          Expanded(
            child: ListView(
              children: [
                SidebarItem(
                  icon: Icons.dashboard_outlined,
                  label: "dashboard".tr(),
                  active: selectedIndex == 0,
                  minimal: minimal,
                  onTap: () => onItemSelected?.call(0),
                ),
                SidebarItem(
                  icon: Icons.account_tree_outlined,
                  label: "departments".tr(),
                  active: selectedIndex == 1,
                  minimal: minimal,
                  onTap: () => onItemSelected?.call(1),
                ),
                SidebarItem(
                  icon: Icons.apartment_outlined,
                  label: "panchayatSamiti".tr(),
                  active: selectedIndex == 2,
                  minimal: minimal,
                  onTap: () => onItemSelected?.call(2),
                ),
                SidebarItem(
                  icon: Icons.people_outline,
                  label: "gramVikasAdhikari".tr(),
                  active: selectedIndex == 3,
                  minimal: minimal,
                  onTap: () => onItemSelected?.call(3),
                ),
                SidebarItem(
                  icon: Icons.bar_chart_outlined,
                  label: "reports".tr(),
                  active: selectedIndex == 4,
                  minimal: minimal,
                  onTap: () => onItemSelected?.call(4),
                ),
                SidebarItem(
                  icon: Icons.account_balance_wallet_outlined,
                  label: "finance".tr(),
                  active: selectedIndex == 5,
                  minimal: minimal,
                  onTap: () => onItemSelected?.call(5),
                ),
                SidebarItem(
                  icon: Icons.notifications_outlined,
                  label: "notifications".tr(),
                  active: selectedIndex == 6,
                  minimal: minimal,
                  onTap: () => onItemSelected?.call(6),
                ),
                const Divider(height: 36),
                SidebarItem(
                  icon: Icons.settings_outlined,
                  label: "settings".tr(),
                  active: selectedIndex == 7,
                  minimal: minimal,
                  onTap: () => onItemSelected?.call(7),
                ),
                SidebarItem(
                  icon: Icons.logout,
                  label: "logout".tr(),
                  minimal: minimal,
                  onTap: () => onItemSelected?.call(8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final bool minimal;
  final VoidCallback? onTap; // 🔹 Add onTap callback

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    this.active = false,
    this.minimal = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap, // 🔹 Trigger callback
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(
          horizontal: minimal ? 0 : AppSizes.padding,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: active
              ? theme.primaryColor.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: active
              ? Border(
            left: BorderSide(color: theme.primaryColor, width: 3),
          )
              : null,
        ),
        child: Row(
          mainAxisAlignment:
          minimal ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: AppSizes.iconSize,
              color: active ? theme.primaryColor : Colors.grey.shade700,
            ),
            if (!minimal) ...[
              const SizedBox(width: AppSizes.spacing),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    color: active
                        ? theme.primaryColor
                        : Colors.grey.shade800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

