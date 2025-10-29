  import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sidebar extends StatelessWidget {
  final bool minimal;
  final String activeRoute;
  final Function(String route)? onItemSelected;

  const Sidebar({
    super.key,
    this.minimal = false,
    this.activeRoute = "dashboard",
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: minimal ? 80 : 250,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF0D47A1), const Color(0xFF1976D2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(2, 0),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment:
        minimal ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          // 🔷 Header (Zilla Parishad logo + text)
          Row(
            mainAxisAlignment:
            minimal ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white70, width: 2),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/zillha_parishad_logo.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (!minimal) ...[
                const SizedBox(width: 12),
                Text(
                  "ZP Sangli\nBDO Panel",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]
            ],
          ),
          const SizedBox(height: 28),

          // 🔹 Navigation Menu
          Expanded(
            child: ListView(
              children: [
                _SidebarItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  route: 'dashboard',
                  active: activeRoute == 'dashboard',
                  minimal: minimal,
                  onTap: onItemSelected,
                ),
                _SidebarItem(
                  icon: Icons.account_tree_rounded,
                  label: 'Schemes',
                  route: 'schemes',
                  active: activeRoute == 'schemes',
                  minimal: minimal,
                  onTap: onItemSelected,
                ),
                _SidebarItem(
                  icon: Icons.insights_rounded,
                  label: 'Progress Reports',
                  route: 'progress',
                  active: activeRoute == 'progress',
                  minimal: minimal,
                  onTap: onItemSelected,
                ),
                _SidebarItem(
                  icon: Icons.apartment_rounded,
                  label: 'Departments',
                  route: 'departments',
                  active: activeRoute == 'departments',
                  minimal: minimal,
                  onTap: onItemSelected,
                ),
                _SidebarItem(
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Finance',
                  route: 'finance',
                  active: activeRoute == 'finance',
                  minimal: minimal,
                  onTap: onItemSelected,
                ),
                _SidebarItem(
                  icon: Icons.feedback_rounded,
                  label: 'Public Feedback',
                  route: 'feedback',
                  active: activeRoute == 'feedback',
                  minimal: minimal,
                  onTap: onItemSelected,
                ),
                _SidebarItem(
                  icon: Icons.report_problem_rounded,
                  label: 'Complaints',
                  route: 'complaints',
                  active: activeRoute == 'complaints',
                  minimal: minimal,
                  onTap: onItemSelected,
                ),
                _SidebarItem(
                  icon: Icons.people_alt_rounded,
                  label: 'Staff Directory',
                  route: 'staff',
                  active: activeRoute == 'staff',
                  minimal: minimal,
                  onTap: onItemSelected,
                ),
                _SidebarItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  route: 'settings',
                  active: activeRoute == 'settings',
                  minimal: minimal,
                  onTap: onItemSelected,
                ),
              ],
            ),
          ),

          // 🔸 Footer Info
          if (!minimal)
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white70, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Block Development Officer\nZilla Parishad Sangli',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.white70,
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
}

// ─────────────────────────────
// 🔹 Sidebar Item Widget
// ─────────────────────────────
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
    final bgColor = active ? Colors.white.withOpacity(0.15) : Colors.transparent;
    final textColor = active ? Colors.white : Colors.white70;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onTap?.call(route),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(
          horizontal: minimal ? 0 : 12,
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
            Icon(icon, color: textColor, size: 26), // larger icon
            if (!minimal) ...[
              const SizedBox(width: 16),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 18, // larger font size
                  color: textColor,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
