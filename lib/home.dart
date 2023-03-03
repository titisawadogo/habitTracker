import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habitTile.dart';
import 'package:habit_tracker/data/dataBase.dart';
import 'package:hive/hive.dart';

import 'components/monthSummary.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  TextEditingController _newHabit = TextEditingController();

  HabitDatabase db = HabitDatabase();
  final myBox = Hive.box('habitDataBase');

  @override
  void initState() {
    // TODO: implement initState

    if (myBox.get('currentList') == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }

    db.updateData();

    super.initState();
  }

  void checkBoxtapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateData();
  }

  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: _newHabit,
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    db.todaysHabitList.add([_newHabit.text, false]);
                  });
                  _newHabit.clear();
                  Navigator.of(context).pop();
                  db.updateData();
                },
                child: Text('Save'),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  _newHabit.clear();
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
  }

  void openSettings(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: _newHabit,
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    db.todaysHabitList[index][0] = _newHabit.text;
                  });
                  //
                  Navigator.pop(context);
                  db.updateData();
                },
                child: Text('Save'),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  _newHabit.clear();
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
  }

  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[200],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[300],
        onPressed: createNewHabit,
        child: Icon(
          Icons.add,
        ),
      ),
      body: ListView(children: [
        monthlySummary(
          datasets: db.heatMapDataSet,
          startDate: myBox.get("startDate"),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: db.todaysHabitList.length,
          itemBuilder: (context, index) {
            return HabitTile(
                habitN: db.todaysHabitList[index][0],
                isHabitCompleted: db.todaysHabitList[index][1],
                onChanged: (value) => checkBoxtapped(value, index),
                settingsTap: (context) => openSettings(index),
                deletedTap: (context) => deleteHabit(index));
          },
        ),
      ]),
    );
  }
}
