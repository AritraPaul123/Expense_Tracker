import 'package:expense_tracker/constants.dart';
import 'package:flutter/material.dart';

import '../../models/expense_model.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({super.key, required this.expense});
  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      color: Colors.white70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(expense.title, style: Theme.of(context).textTheme.titleLarge),
            Row(
              children: [
                Text("\$${expense.expense}"),
                const Spacer(),
                Icon(categoryIcons[expense.category]),
                const SizedBox(width: 5),
                Text(expense.formattedDate)
              ],
            )
          ],
        ),
      ),
    );
  }
}
