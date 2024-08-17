import 'package:flutter/material.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 96, 59, 181));

var kDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 5, 99, 125));

enum Category { all, leisure, travel, food, work }

Map categoryIcons = {
  Category.leisure: Icons.movie,
  Category.travel: Icons.flight_takeoff,
  Category.food: Icons.fastfood_rounded,
  Category.work: Icons.work
};

int getWeekNumber(DateTime dateTime) {
  DateTime firstDayYear = DateTime(dateTime.year, 1, 1);
  int daysPassed = dateTime.difference(firstDayYear).inDays;
  return (daysPassed / 7).ceil();
}
