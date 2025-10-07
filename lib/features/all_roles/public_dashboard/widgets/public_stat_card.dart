import 'package:flutter/material.dart';
import 'package:zp_sangali_dashboard_flutter/core/widgets/responsive_texts.dart';
import '../../../../core/widgets/responsive_layout.dart';

class PublicStatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String hint;
  final IconData? icon;
  final Color color;

  const PublicStatCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.hint,
    this.icon,
    this.color = const Color(0xFFF9FAFB),
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildCard(context, compact: true),
      tablet: _buildCard(context),
      desktop: _buildCard(context, spacious: true),
    );
  }

  Widget _buildCard(BuildContext context,
      {bool compact = false, bool spacious = false}) {
    final bool isNegative = hint.trim().startsWith('-');

    return Container(
      constraints: const BoxConstraints(minHeight: 120, minWidth: 140),
      padding: EdgeInsets.all(compact ? 12 : 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.98), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(compact ? 14 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top row: icon + hint chip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon != null)
                CircleAvatar(
                  radius: compact ? 16 : 20,
                  backgroundColor: Colors.white.withOpacity(0.8),
                  child: Icon(icon,
                      size: compact ? 16 : 20, color: Colors.black87),
                ),
              Flexible(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isNegative ? Colors.red : Colors.green)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isNegative
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        size: 14,
                        color: isNegative ? Colors.red : Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          hint,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: context.scaledFont(12),
                            fontWeight: FontWeight.w600,
                            color: isNegative ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Big Title (main stat) with shrinkable font
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: context.scaledFont(spacious ? 32 : 26),
                fontWeight: FontWeight.w800,
                color: const Color(0xFF111111),
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 6),

          /// Subtitle (auto-wrap)
          Text(
            subtitle,
            maxLines: compact ? 2 : 3,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: context.scaledFont(13),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF555555),
            ),
          ),

        ],
      ),
    );
  }
}
