import 'package:flutter/material.dart';

import '../../models/expense.dart';

// INFO: This class is for each of the expense item in the expense list
class ExpenseItem extends StatelessWidget{
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    // TODO: INFO: For pronto use some unique form of Card below -- Like however to get more info or something.. maybe phase 2
    return Card(
      child: Padding(
         padding: const EdgeInsets.symmetric(
           horizontal: 20,
           vertical: 16
         ),
          child: Column(
            children: [
              // TODO: Format the below text field
              Text(expense.title),
              Text(expense.bank),
              Text(expense.type.name),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text('\$${expense.amount.toStringAsFixed(2)}'),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(categoryIcons[expense.category]),
                      const SizedBox(width: 20,),
                      Text(expense.formatterDate)
                    ],
                  )
                ],
              )
            ],
          ),
      ),

    );
  }

}