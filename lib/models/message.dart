
// TODO: Get to whom the money was sent from the message.
// TODO: PHASE2 : Get the location and save it with the expense.

class TransacMessage{
  TransacMessage({
    required this.amount,
    required this.type,
    required this.bank,
    required this.date
  });

  final String? amount;
  final String? type;
  final String? bank;
  // TODO: Change below to date time
  final String? date;
}