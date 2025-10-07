import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/responsive_texts.dart';

class AdditionalCeoSidebar extends StatelessWidget {
  final String activeRoute;
  final Function(String route)? onItemSelected;

  const AdditionalCeoSidebar({
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
        ? 260
        : isTablet
        ? 200
        : 70;
    final double headerFontSize = context.scaleText(16);

    return Container(
      width: sidebarWidth,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 16 : 24,
        horizontal: isMobile ? 8 : 16,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(3, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          // 🔹 Header
          Row(
            mainAxisAlignment: isMobile
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Container(
                height: isDesktop ? 52 : 42,
                width: isDesktop ? 52 : 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white70, width: 2),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/zillha_parishad_logo.jpg'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 6,
                    )
                  ],
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: Marquee(
                      text: "ZP Sangli Additional CEO Panel",
                      style: GoogleFonts.poppins(
                        fontSize: headerFontSize,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      scrollAxis: Axis.horizontal,
                      blankSpace: 20.0,
                      velocity: 25.0,
                      pauseAfterRound: const Duration(seconds: 1),
                    ),
                  ),
                ),
              ],
            ],
          ),

          SizedBox(height: isMobile ? 16 : 30),
          Divider(color: Colors.white.withOpacity(0.3), thickness: 0.8),
          const SizedBox(height: 10),

          // 🔹 Navigation
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
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

          // 🔹 Footer
          if (!isMobile) ...[
            const Divider(color: Colors.white24, thickness: 0.8),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "© ZP Sangli",
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
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
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final double iconSize = widget.minimal ? 22 : 24;
    final double fontSize = widget.minimal ? 14 : 16;

    final Color activeColor = Colors.white;
    final Color inactiveColor = Colors.white70;

    final bool isActive = widget.active;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => widget.onTap?.call(widget.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.symmetric(
            horizontal: widget.minimal ? 4 : 14,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withOpacity(0.18)
                : isHovering
                ? Colors.white.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isActive
                ? Border(
              left: BorderSide(
                color: Colors.white,
                width: 3.5,
              ),
            )
                : null,
          ),
          child: Row(
            mainAxisAlignment: widget.minimal
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(
                widget.icon,
                color: isActive ? activeColor : inactiveColor,
                size: iconSize,
              ),
              if (!widget.minimal) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.label,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: fontSize,
                      color: isActive ? activeColor : inactiveColor,
                      fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
