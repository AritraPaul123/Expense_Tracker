import 'package:expense_tracker/views/widgets/expense_card.dart';
import 'package:flutter/material.dart';
import '../../models/expense_model.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {super.key, required this.onRemoveExpense, required this.expenses});

  final void Function(Expense expense) onRemoveExpense;
  final List<Expense> expenses;

  @override
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            return Dismissible(
                key: ValueKey(index),
                background: Container(
                    color:
                        Theme.of(context).colorScheme.error.withOpacity(0.75),
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            Theme.of(context).cardTheme.margin!.horizontal)),
                onDismissed: (direction) {
                  onRemoveExpense(expenses[index]);
                },
                child: ExpenseCard(expense: expenses[index]));
          },
        ),
      ),
    );
  }
}
