import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/json_data_model.dart';



class KpiList extends StatefulWidget {
  final List<ApiItem> items;
  const KpiList({required this.items});

  @override
  State<KpiList> createState() => KpiListState();
}

class KpiListState extends State<KpiList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final items = widget.items;
    if (items.isEmpty) return const Center(child: Text("No data"));

    return ListView.builder(
      key: ValueKey(items.length),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final it = items[i];
        final percent =
        it.target == 0 ? 0.0 : (it.achievement / it.target * 100);
        return ListTile(
          title: Text(it.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: LinearProgressIndicator(
            value: (percent / 100).clamp(0, 1),
            color: percent > 80 ? Colors.green : Colors.orange,
            backgroundColor: Colors.grey.shade200,
          ),
          trailing: Text("${percent.toStringAsFixed(1)}%"),
        );
      },
    );
  }
}