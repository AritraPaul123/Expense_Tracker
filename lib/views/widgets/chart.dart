import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/views/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense_model.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.allExpenses});

  final List<Expense> allExpenses;

  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(allExpenses, Category.work),
      ExpenseBucket.forCategory(allExpenses, Category.food),
      ExpenseBucket.forCategory(allExpenses, Category.travel),
      ExpenseBucket.forCategory(allExpenses, Category.leisure),
    ];
  }

  double get maxTotalExpense {
    double maxExpense = 0;
    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxExpense) {
        maxExpense = bucket.totalExpenses;
      }
    }
    return maxExpense;
  }

  @override
  Widget build(BuildContext context) {
    var isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0),
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets)
                  ChartBar(fill: bucket.totalExpenses / maxTotalExpense)
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: buckets
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(categoryIcons[bucket.category],
                          color: isDarkMode
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.7)),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
