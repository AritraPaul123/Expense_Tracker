import 'package:hive_flutter/hive_flutter.dart';
import '../constants.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'expense_model.g.dart';

DateFormat formatter = DateFormat.yMd();
const uuid = Uuid();

@HiveType(typeId: 0)
class Expense extends HiveObject {
  Expense(
      {required this.title,
      required this.expense,
      required this.dateTime,
      required this.category})
      : id = uuid.v4();

  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String expense;
  @HiveField(3)
  DateTime dateTime;
  @HiveField(4)
  Category category;

  String get formattedDate {
    return formatter.format(dateTime);
  }
}

class ExpenseBucket {
  final Category category;
  final List<Expense> expenses;
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += double.parse(expense.expense);
    }
    return sum;
  }
}
