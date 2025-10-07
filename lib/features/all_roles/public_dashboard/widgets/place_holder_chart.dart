import 'package:flutter/material.dart';


class PublicPlaceholderChart extends StatelessWidget {
  final double height;
  final String label;
  const PublicPlaceholderChart({super.key, required this.height, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
      ),
      child: Center(child: Text(label, style: TextStyle(color: Colors.grey.shade600))),
    );
  }
}
