import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:pronto/main.dart';
import 'package:provider/provider.dart';
import 'package:telephony/telephony.dart';

import '../models/expense.dart';
import '../models/message.dart';
import '../new_expense.dart';
import '../notification.dart';
import '../parse.dart';
import 'expenses_list.dart';

// When app in background, notification will be sent to the phone, clicking which will open the overlay with the pre filled info.
onMessageAppInBackground(SmsMessage receivedMessage) {
  TransacMessage transacMessage = parseMessage(receivedMessage.body ?? '');
  print(transacMessage.amount);
  //TODO: This function should update the list... But will it reflect in the widget in app when app is opened from notification.
  NotificationService()
      .showNotification(title: 'Add Expense', body: 'click to add expense');
//   TODO: The problem: I want to call a function inside a widget class from an outside function -- Essentially either it should open the app or start from where it left
}

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Flutter Course",
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work,
        type: TypeOfTransaction.credit,
        bank: 'SBI'),
    Expense(
        title: "Car",
        amount: 299.99,
        date: DateTime.now(),
        category: Category.leisure,
        type: TypeOfTransaction.debit,
        bank: 'Axis Bank')
  ];

  String bank = "null";
  String amount = "null";
  String date = "null";
  String typeOfTransaction = "null";
  String testVal = "Charles";

  final telephony = Telephony.backgroundInstance;

  //Change the state of this page which is showing list of expenses
  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Expense Deleted'),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: "Undo",
        onPressed: () {
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        },
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // startCheckingList();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;
    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessageAppInForeground,
          onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }

  // When pronto is open then it should show the overlay directly.
  onMessageAppInForeground(SmsMessage receivedMessage) async {
    setState(() {
      TransacMessage transacMessage = parseMessage(receivedMessage.body ?? '');
      bank = transacMessage.bank!;
      amount = transacMessage.amount!;
      date = transacMessage.date!;
      typeOfTransaction = transacMessage.type!;

      //TODO: Here we have to find some library which can parse the date out of messages in DateTime format ---
      // DateTime parsedDate = DateTime.parse(date);
      _openAddExpenseOverlay(amount, bank, DateTime.now());
    });
  }

  void _openAddExpenseOverlay(String amount, String bank, DateTime date) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(
              onAddExpense: _addExpense,
              amount: amount,
              bank: bank,
              date: date,
            ));
  }

  //To add a delay in notification, Use the function like below
  Future<void> delayedNotification() async {
    await Future.delayed(const Duration(seconds: 5));
    NotificationService()
        .showNotification(title: 'Sample title', body: 'It works!');
  }

  static void onBackgroundMessage(SmsMessage receivedMessage) {
    // Extract the message content and take the desired action.
    TransacMessage transacMessage = parseMessage(receivedMessage.body ?? '');
    print(transacMessage.amount);
    //TODO: This function should update the list... But will it reflect in the widget in app when app is opened from notification.
    NotificationService()
        .showNotification(title: 'Add Expense', body: 'click to add expense');
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //     builder: (context) => MessageDetailsScreen(messageBody),
    // )
  }

  // INFO: context below has metadata info related to this widget
  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No Expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: _registeredExpenses, onRemoveExpense: _removeExpense);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Pronto"),
        actions: [
          IconButton(
            onPressed: () => _openAddExpenseOverlay('0', 'SBI', DateTime.now()),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          const Text("The Chart"),
          Expanded(
            child: mainContent,
          ),
          TextButton(
              onPressed: delayedNotification,
              child: const Text('Click Here for Notification')),
          Text("bank: $bank"),
          Text("Amount: $amount"),
          Text("type: $typeOfTransaction"),
          Text("date: $date"),
          Text(testVal)
        ],
      ),
    );
  }
}
