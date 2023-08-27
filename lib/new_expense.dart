import 'package:flutter/material.dart';
import 'package:pronto/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense, required this.amount,required this.bank, required this.date});

  //INFO: In flutter we can put function in a variable as well. This function is then passed from expenses.dart
  final void Function(Expense expense) onAddExpense;

  final String amount;
  final String bank;
  final DateTime date;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  //TODO: LATER: We will require the below fields to be stored in DB
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _bankController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;
  TypeOfTransaction _selectedTransactionType = TypeOfTransaction.debit;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.amount;
    _bankController.text = widget.bank;
    _selectedDate = widget.date;
  }

  //void initState(){} --> Initialise the controllers and variables --> Can we pass something to it?

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = now;
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseDate() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure valid title, amount, date and category was entered'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
      return;
    }
    //Logic of Saving the expenses data

    //Create a new expense item
    var expense = Expense(
        amount: enteredAmount,
        type: _selectedTransactionType,
        bank: _bankController.text,
        date: _selectedDate!,
        title: _titleController.text,
        category: _selectedCategory);

    //Call the function to update the expenses list
    widget.onAddExpense(expense);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  //INFO: Below is another way of handling text input.
  // var _enteredTitle = '';
  //
  // void _saveTitleInput(String inputValue){
  //   _enteredTitle = inputValue;
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            // onChanged: _saveTitleInput,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    prefixText: '\$',
                    label: Text('Amount'),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Selected Date'
                        : formatter.format(_selectedDate!),
                  ),
                  IconButton(
                    onPressed: _presentDatePicker,
                    icon: const Icon(Icons.calendar_month),
                  ),
                ],
              ))
            ],
          ),
          const SizedBox(width: 16),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _bankController,
                maxLength: 10,
                decoration: const InputDecoration(
                  label: Text('Bank'),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          category.name.toUpperCase(),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButton(
                value: _selectedTransactionType,
                items: TypeOfTransaction.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          category.name.toUpperCase(),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(
                    () {
                      _selectedTransactionType = value;
                    },
                  );
                },
              ),
            ),
          ]),
          Row(
            children: [
              ElevatedButton(
                onPressed: _submitExpenseDate,
                child: const Text('Save Expense'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              )
            ],
          )
        ],
      ),
    );
  }
}
