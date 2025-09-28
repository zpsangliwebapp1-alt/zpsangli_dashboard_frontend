import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CeoPieChart extends StatefulWidget {
  final Map<String, double> data;
  final double initialRotation; // allow passing initial rotation

  const CeoPieChart({
    super.key,
    required this.data,
    this.initialRotation = -90, // default start rotated (top aligned)
  });

  @override
  State<CeoPieChart> createState() => _CeoPieChartState();
}

class _CeoPieChartState extends State<CeoPieChart> {
  late double _rotation; // track rotation manually
  int? _touchedIndex;

  @override
  void initState() {
    super.initState();
    _rotation = widget.initialRotation; // set starting rotation
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.deepPurple,
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.teal,
    ];

    final entries = widget.data.entries.toList();

    return Column(
      children: [
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _rotation += details.delta.dx * 0.5; // drag to rotate
            });
          },
          child: SizedBox(
            height: 260,
            child: PieChart(
              PieChartData(
                startDegreeOffset: _rotation, // apply rotation
                centerSpaceRadius: 45,
                sectionsSpace: 2,
                pieTouchData: PieTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    if (!event.isInterestedForInteractions ||
                        response == null ||
                        response.touchedSection == null) {
                      setState(() => _touchedIndex = null);
                      return;
                    }
                    setState(() {
                      _touchedIndex = response.touchedSection!
                          .touchedSectionIndex; // highlight on touch
                    });
                  },
                ),
                sections: [
                  for (int i = 0; i < entries.length; i++)
                    PieChartSectionData(
                      value: entries[i].value,
                      title: "${entries[i].value.toInt()}",
                      color: colors[i % colors.length],
                      radius: _touchedIndex == i ? 80 : 70, // zoom effect
                      titleStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 🔹 Indicators (Legends)
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            for (int i = 0; i < entries.length; i++)
              _buildIndicator(
                color: colors[i % colors.length],
                text: entries[i].key,
                value: entries[i].value,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildIndicator({
    required Color color,
    required String text,
    required double value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          "$text (${value.toInt()})",
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
