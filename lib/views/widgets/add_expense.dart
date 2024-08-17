import 'dart:io';
import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/models/expense_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category? _selectedCategory = Category.leisure;

  void selectDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    var pickedDate = _selectedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpense() async {
    final enteredAmount = double.tryParse(_amountController.text);
    bool invalidAmount = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        invalidAmount ||
        _selectedDate == null) {
      Platform.isAndroid
          ? showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Invalid input"),
                    content: const Text(
                        "Please make sure a valid title, amount, date and category was entered."),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "OKAY",
                            style: TextStyle(fontSize: 16),
                          ))
                    ],
                  ))
          : showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                    title: const Text("Invalid input"),
                    content: const Text(
                        "Please make sure a valid title, amount, date and category was entered."),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "OKAY",
                            style: TextStyle(fontSize: 16),
                          ))
                    ],
                  ));
      return;
    }
    widget.onAddExpense(Expense(
        title: _titleController.text,
        expense: _amountController.text,
        dateTime: _selectedDate!,
        category: _selectedCategory!));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      var width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration:
                              const InputDecoration(label: Text("Title")),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              label: Text("Amount"), prefix: Text("\$ ")),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(label: Text("Title")),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name.toUpperCase()),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      const Spacer(),
                      Text(_selectedDate == null
                          ? "No Date Selected"
                          : formatter.format(_selectedDate!)),
                      IconButton(
                          onPressed: selectDate,
                          icon: const Icon(Icons.calendar_month))
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              label: Text("Amount"), prefix: Text("\$ ")),
                        ),
                      ),
                      const Spacer(),
                      Text(_selectedDate == null
                          ? "No Date Selected"
                          : formatter.format(_selectedDate!)),
                      IconButton(
                          onPressed: selectDate,
                          icon: const Icon(Icons.calendar_month))
                    ],
                  ),
                // const SizedBox(height: 5),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      const SizedBox(width: 8),
                      ElevatedButton(
                          onPressed: _submitExpense,
                          child: const Text("Save Response")),
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name.toUpperCase()),
                                  ))
                              .toList()
                            ..removeAt(0),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      const Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      const SizedBox(width: 8),
                      ElevatedButton(
                          onPressed: _submitExpense,
                          child: const Text("Save Response")),
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
