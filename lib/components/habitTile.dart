import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  const HabitTile(
      {super.key,
      required this.habitN,
      required this.isHabitCompleted,
      required this.onChanged,
      required this.settingsTap,
      required this.deletedTap});

  final String habitN;
  final bool isHabitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTap;
  final Function(BuildContext)? deletedTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Slidable(
          endActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                borderRadius: BorderRadius.circular(15),
                onPressed: settingsTap,
                backgroundColor: Colors.grey.shade800,
                icon: Icons.settings,
              ),
              SlidableAction(
                borderRadius: BorderRadius.circular(15),
                onPressed: deletedTap,
                backgroundColor: Colors.red,
                icon: Icons.delete,
              )
            ],
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Row(children: [
              Checkbox(
                value: isHabitCompleted,
                onChanged: onChanged,
              ),
              Text(habitN)
            ]),
          ),
        ));
  }
}
