// lib/ui/widgets/ekatmik_balvikas_yojna_sidebar.dart
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final bool minimal;
  const Sidebar({super.key, this.minimal = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo / App name
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Icon(Icons.dashboard, color: Colors.white)),
              ),
              if (!minimal) ...[
                const SizedBox(width: 12),
                const Text(
                  'Dabang',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ]
            ],
          ),
          const SizedBox(height: 28),

          // Navigation items
          Expanded(
            child: ListView(
              children: [
                SidebarItem(
                  icon: Icons.pie_chart,
                  label: 'Dashboard',
                  active: true,
                  minimal: minimal,
                ),
                SidebarItem(icon: Icons.leaderboard, label: 'Leaderboard', minimal: minimal),
                SidebarItem(icon: Icons.shopping_cart, label: 'Order', minimal: minimal),
                SidebarItem(icon: Icons.store, label: 'Products', minimal: minimal),
                SidebarItem(icon: Icons.bar_chart, label: 'Sales Report', minimal: minimal),
                SidebarItem(icon: Icons.message, label: 'Messages', minimal: minimal),
                SidebarItem(icon: Icons.settings, label: 'Settings', minimal: minimal),
                SidebarItem(icon: Icons.logout, label: 'Sign Out', minimal: minimal),
              ],
            ),
          ),

          // Dabang Pro card (only in full sidebar)
          if (!minimal) ...[
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade400,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dabang Pro',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Get access to all\nfeatures on tebuntas',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Get Pro'),
                    ),
                  ),
                ],
              ),
            )
          ]
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

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    this.active = false,
    this.minimal = false,
  });

  @override
  Widget build(BuildContext context) {
    final base = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: active ? Colors.deepPurple : Colors.grey.shade700,
          ),
          if (!minimal) ...[
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.deepPurple : Colors.grey.shade800,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ]
        ],
      ),
    );

    if (active && !minimal) {
      return Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: base,
      );
    }

    return base;
  }
}
