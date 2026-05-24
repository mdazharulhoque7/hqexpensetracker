import 'package:flutter/material.dart';
import 'package:hqexpensetracker/models/expense.dart';
import 'package:hqexpensetracker/widgets/expenses/expenses_list/expense_item.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  final Function(Expense expense) onRemoveExpense;

  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]),
        onDismissed: (direction) => onRemoveExpense(expenses[index]),
        background: Container(
          color: Theme.of(context).colorScheme.primary.withAlpha(50),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal)
        ),
        child: ExpenseItem(expenses[index]),
      ),
    );
  }
}
