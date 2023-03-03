import 'package:flutter/material.dart';
import 'package:habit_tracker/datetime/dateTime.dart';
import 'package:hive_flutter/hive_flutter.dart';

final myBox = Hive.box("habitDataBase");

class HabitDatabase {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  void createDefaultData() {
    todaysHabitList = [
      ["Run", false],
      ["Read", false]
    ];

    myBox.put('startDate', todaysDateFormatted());
  }

  void loadData() {
    if (myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = myBox.get("currentList");

      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    } else {
      todaysHabitList = myBox.get(todaysDateFormatted());
    }
  }

  void updateData() {
    myBox.put(todaysDateFormatted(), todaysHabitList);

    myBox.put("currentList", todaysHabitList);

    calculateHabitPercentages();

    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = todaysHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todaysHabitList.length).toStringAsFixed(1);

    myBox.put("percentageSummary${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(myBox.get("startDate"));

    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        myBox.get("percentageSummary$yyyymmdd") ?? "0.0",
      );

      int year = startDate.add(Duration(days: i)).year;

      int month = startDate.add(Duration(days: i)).month;

      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      //print(heatMapDataSet);
    }
  }
}
