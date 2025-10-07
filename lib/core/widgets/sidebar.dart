import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/responsive_texts.dart';

import '../../features/all_roles/BDO_dashboard/widgets/responsive_layout.dart';
class BdoSidebar extends StatelessWidget {
  final String activeRoute;
  final Function(String route)? onItemSelected;

  const BdoSidebar({
    super.key,
    this.activeRoute = "dashboard",
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveLayout.isDesktop(context);
    final bool isTablet = ResponsiveLayout.isTablet(context);
    final bool isMobile = ResponsiveLayout.isMobile(context);

    final double sidebarWidth = isDesktop
        ? 250
        : isTablet
        ? 200
        : 70;
    final double iconSize = isDesktop
        ? 26
        : isTablet
        ? 24
        : 22;
    final double fontSize = context.scaleText(18); // uses your extension
    final double headerFontSize = context.scaleText(16);

    return Container(
      width: sidebarWidth,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 16 : 20,
        horizontal: isMobile ? 8 : 16,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment:
            isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Container(
                height: isDesktop ? 48 : isTablet ? 40 : 36,
                width: isDesktop ? 48 : isTablet ? 40 : 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white70, width: 2),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/zillha_parishad_logo.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 12),
                Text(
                  "ZP Sangli\nBDO Panel",
                  style: GoogleFonts.poppins(
                    fontSize: headerFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]
            ],
          ),
          SizedBox(height: isMobile ? 16 : 28),

          // Navigation
          Expanded(
            child: ListView(
              children: [
                _SidebarItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  route: 'dashboard',
                  active: activeRoute == 'dashboard',

                  minimal: isMobile,
                  onTap: onItemSelected,
                ),
                _SidebarItem(
                  icon: Icons.account_tree_rounded,
                  label: 'Schemes',
                  route: 'schemes',
                  active: activeRoute == 'schemes',

                  minimal: isMobile,
                  onTap: onItemSelected,
                ),
                _SidebarItem(
                  icon: Icons.insights_rounded,
                  label: 'Progress Reports',
                  route: 'progress',
                  active: activeRoute == 'progress',

                  minimal: isMobile,
                  onTap: onItemSelected,
                ),
                _SidebarItem(
                  icon: Icons.apartment_rounded,
                  label: 'Departments',
                  route: 'departments',
                  active: activeRoute == 'departments',

                  minimal: isMobile,
                  onTap: onItemSelected,
                ),
                _SidebarItem(
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Finance',
                  route: 'finance',
                  active: activeRoute == 'finance',

                  minimal: isMobile,
                  onTap: onItemSelected,
                ),
                _SidebarItem(
                  icon: Icons.feedback_rounded,
                  label: 'Public Feedback',
                  route: 'feedback',
                  active: activeRoute == 'feedback',

                  minimal: isMobile,
                  onTap: onItemSelected,
                ),
                _SidebarItem(
                  icon: Icons.report_problem_rounded,
                  label: 'Complaints',
                  route: 'complaints',
                  active: activeRoute == 'complaints',

                  minimal: isMobile,
                  onTap: onItemSelected,
                ),
                _SidebarItem(
                  icon: Icons.people_alt_rounded,
                  label: 'Staff Directory',
                  route: 'staff',
                  active: activeRoute == 'staff',

                  minimal: isMobile,
                  onTap: onItemSelected,
                ),
                _SidebarItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  route: 'settings',
                  active: activeRoute == 'settings',

                  minimal: isMobile,
                  onTap: onItemSelected,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final bool minimal;
  final String route;
  final Function(String route)? onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.route,
    this.active = false,
    this.minimal = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive sizes
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 1024;
    final bool isTablet = width >= 600 && width < 1024;
    final bool isMobile = width < 600;

    final double iconSize = isDesktop
        ? 28
        : isTablet
        ? 24
        : 22;

    final double fontSize = isDesktop
        ? 20
        : isTablet
        ? 18
        : 16;

    final double horizontalPadding = isDesktop
        ? 16
        : isTablet
        ? 12
        : 8;

    final bgColor = active ? Colors.white.withOpacity(0.15) : Colors.transparent;
    final textColor = active ? Colors.white : Colors.white70;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onTap?.call(route),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(
          horizontal: minimal ? 4 : horizontalPadding,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment:
          minimal ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(icon, color: textColor, size: iconSize),
            if (!minimal) ...[
              const SizedBox(width: 12),
              // Prevent overflow
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    color: textColor,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.5,
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

