import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TypeOfTransaction {credit, debit, cash}
enum Category {food, travel, leisure, work}

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work
};

final formatter = DateFormat.yMMMd();

class Expense{
  Expense({
    required this.amount,
    required this.type,
    required this.bank,
    required this.date,
    required  this.title,
    required this.category,
  });

  // TODO: There is some problem coming in the fields which are not final type.

  final title;
  final double amount;
  final TypeOfTransaction type;
  final String bank;
  final DateTime date;
  final Category category;
  String description = "Enter a description";

  // INFO: Below is a getter in flutter
  String get formatterDate{
    return formatter.format(date);
  }
}