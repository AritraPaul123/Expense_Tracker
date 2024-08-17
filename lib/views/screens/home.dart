import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/views/widgets/add_expense.dart';
import 'package:expense_tracker/views/widgets/chart.dart';
import 'package:expense_tracker/views/widgets/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final box = Hive.box<Expense>('Expenses');
  var filter = Category.all;
  String _selectedRange = "All";

  void addExpense(Expense expense) {
    setState(() {
      box.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    setState(() {
      expense.delete();
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text("Expense Removed"),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              box.add(expense);
            });
          }),
    ));
  }

  void addExpenseOverlay(BuildContext context) {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => AddExpense(onAddExpense: addExpense));
  }

  Future<void> _openBox() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  List<Expense> filterBox(Category category, String dateRange) {
    DateTime now = DateTime.now();
    if (dateRange == "All") {
      return category == Category.all
          ? box.values.where((expense) => true).toList()
          : box.values
              .where((expense) => expense.category == category)
              .toList();
    } else if (dateRange == "This Month") {
      return category == Category.all
          ? box.values
              .where((expense) => true && expense.dateTime.month == now.month)
              .toList()
          : box.values
              .where((expense) => expense.category == category)
              .toList();
    } else if (dateRange == "Last Month") {
      return category == Category.all
          ? box.values
              .where(
                  (expense) => true && expense.dateTime.month == now.month - 1)
              .toList()
          : box.values
              .where((expense) => expense.category == category)
              .toList();
    } else if (dateRange == "This Week") {
      return category == Category.all
          ? box.values
              .where((expense) =>
                  true && getWeekNumber(expense.dateTime) == getWeekNumber(now))
              .toList()
          : box.values
              .where((expense) => expense.category == category)
              .toList();
    } else {
      return category == Category.all
          ? box.values
              .where((expense) =>
                  true &&
                  getWeekNumber(expense.dateTime) == getWeekNumber(now) - 1)
              .toList()
          : box.values
              .where((expense) => expense.category == category)
              .toList();
    }
  }

  @override
  void dispose() {
    Hive.close();
    box.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent;
    if (box.isNotEmpty) {
      mainContent = FutureBuilder(
          future: _openBox(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ExpenseList(
                expenses: filterBox(filter, _selectedRange),
                onRemoveExpense: _removeExpense,
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });
      setState(() {});
    } else {
      mainContent = const Center(
        child: Text(
          "No Expenses, Add Some!",
          style: TextStyle(fontSize: 18),
        ),
      );
      setState(() {});
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.filter_list_sharp),
              onSelected: (value) {
                setState(() {
                  filter = value;
                });
              },
              itemBuilder: (BuildContext context) => Category.values
                  .map((category) => PopupMenuItem(
                      value: category,
                      child: Text(category.name.toUpperCase())))
                  .toList()),
          const SizedBox(width: 15),
          SizedBox(
            width: _selectedRange != "All" ? 107 : 75,
            child: DropdownButton(
                underline: Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.8),
                ),
                isExpanded: true,
                hint: Text(
                  _selectedRange,
                  style: ThemeData()
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: kColorScheme.secondaryContainer),
                ),
                items: const [
                  DropdownMenuItem(value: "All", child: Text("All")),
                  DropdownMenuItem(
                      value: "This Month", child: Text("This Month")),
                  DropdownMenuItem(
                      value: "Last Month", child: Text("Last Month")),
                  DropdownMenuItem(
                      value: "This Week", child: Text("This Week")),
                  DropdownMenuItem(
                      value: "Last Week", child: Text("Last Week")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRange = value!;
                  });
                }),
          ),
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 34,
            ),
            onPressed: () {
              addExpenseOverlay(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          if (box.isNotEmpty) Chart(allExpenses: box.values.toList()),
          const SizedBox(height: 5),
          mainContent
        ],
      ),
    );
  }
}
