import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class EkatmikBalvikasYojnaSidebar extends StatelessWidget {
  final bool minimal;
  final String? selected;
  final Function(String)? onItemSelected;

  const EkatmikBalvikasYojnaSidebar({
    super.key,
    this.minimal = false,
    this.selected,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: minimal ? 88 : 260,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade800, Colors.deepPurple.shade600],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          /// 🔹 Sidebar Header (Logo + Department Name)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:
              minimal ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                /// Department Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/images/applogo.jpg", // 🔹 तुझं logo इथे द्यावं
                    height: 40,
                    width: 40,
                    fit: BoxFit.contain,
                  ),
                ),

                if (!minimal) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Ekatmik\nBalvikas Yojna",
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

          const Divider(
            color: Colors.white24,
            thickness: 1,
            height: 1,
          ),

          /// 🔹 Sidebar Menu
          Expanded(
            child: ListView(
              children: [
                _buildItem(Icons.dashboard, "Dashboard"),
                _buildItem(Icons.bar_chart, "Reports"),
                _buildItem(Icons.people, "Beneficiaries"),
                _buildItem(Icons.notifications, "Alerts"),
                _buildItem(Icons.settings, "Settings"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Sidebar Item
  Widget _buildItem(IconData icon, String label) {
    final isActive = selected == label;

    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? Colors.white : Colors.white70,
      ),
      title: !minimal
          ? Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white70,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      )
          : null,
      onTap: () => onItemSelected?.call(label),
    );
  }
}
