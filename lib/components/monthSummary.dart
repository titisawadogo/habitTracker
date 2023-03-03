import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

import '../datetime/dateTime.dart';

class monthlySummary extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDate;

  const monthlySummary({
    super.key,
    required this.datasets,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25, bottom: 25),
      child: HeatMap(
        startDate: createDateTimeObject(startDate),
        endDate: DateTime.now().add(Duration(days: 0)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.grey[200],
        textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Color.fromARGB(19, 255, 106, 61),
          2: Color.fromARGB(40, 255, 152, 120),
          3: Color.fromARGB(60, 2, 179, 8),
          4: Color.fromARGB(80, 2, 179, 8),
          5: Color.fromARGB(99, 94, 24, 17),
          6: Color.fromARGB(120, 204, 94, 88),
          7: Color.fromARGB(149, 88, 15, 0),
          8: Color.fromARGB(180, 197, 62, 47),
          9: Color.fromARGB(220, 254, 15, 15),
          10: Color.fromARGB(255, 255, 47, 0),
        },
        onClick: (value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value.toString())));
        },
      ),
    );
  }
}
