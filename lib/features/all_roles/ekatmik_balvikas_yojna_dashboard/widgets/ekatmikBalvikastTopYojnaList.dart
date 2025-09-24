import 'package:flutter/material.dart';

class EkatmikBalvikastTopYojnaList extends StatelessWidget {
  const EkatmikBalvikastTopYojnaList({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for Ekatmik Balvikas Yojna (English + Marathi)
    final items = [
      {
        'name_en': 'Anganwadi Centers Operational',
        'name_mr': 'अंगणवाडी केंद्र कार्यरत',
        'percent': 75
      },
      {
        'name_en': 'Children (3-6 yrs) Enrolled',
        'name_mr': 'बालक (३-६ वर्षे) नोंदणी',
        'percent': 62
      },
      {
        'name_en': 'Pregnant Women Benefited',
        'name_mr': 'गर्भवती महिलांना लाभ',
        'percent': 48
      },
      {
        'name_en': 'Supplementary Nutrition Coverage',
        'name_mr': 'पुरक पोषण आच्छादन',
        'percent': 85
      },
      {
        'name_en': 'Health Check-up Camps Held',
        'name_mr': 'आरोग्य शिबिरे आयोजित',
        'percent': 40
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            "",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        ...items.map((it) {
          final value = it['percent'] as int;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                // Index
                Text(
                  '${items.indexOf(it) + 1}'.padLeft(2, '0'),
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 12),

                // Names (English + Marathi)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(it['name_en'] as String,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(it['name_mr'] as String,
                          style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Progress Bar
                SizedBox(
                  width: 140,
                  child: LinearProgressIndicator(
                    value: value / 100,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.teal,
                  ),
                ),

                const SizedBox(width: 12),

                // Percent
                Text('$value%', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
