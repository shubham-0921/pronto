//THIS class will print our list of expenses. 
import 'package:flutter/material.dart';

import '../../models/expense.dart';
import 'expense_item.dart';

class ExpensesList extends StatelessWidget{
  const ExpensesList({super.key, required this.expenses, required this.onRemoveExpense});
  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    // INFO: Here the ListView will create a scrollable widget and using the builder constructor will increase the performance.
    return ListView.builder(itemCount: expenses.length,itemBuilder: (ctx, index) => Dismissible(key: ValueKey(expenses[index]), onDismissed: (direction){onRemoveExpense(expenses[index]);},child: ExpenseItem(expenses[index])),);
  }
}