import 'package:pronto/models/message.dart';

import 'models/banks.dart';

// This function will parse the transaction message and get the required info. There are different regex of different bank messages.
TransacMessage parseMessage(String textMessage) {
  //GET the below values from the transaction message
  String? amount;
  String? type;
  String? date;

  final Banks bank;

  if (textMessage.contains(sbiBank.bankNameToSearchInMessage)){
    bank = sbiBank;
  } else if  (textMessage.contains(axisBank.bankNameToSearchInMessage)){
    bank = axisBank;
  } else{
    // TODO: NEED to fix below, what to do when no bank was detected -- Need to have a case for that
    bank = sbiBank;
  }

  // Extracting the amount
  RegExp amountRegex = RegExp(bank.amountRegex);
  Iterable<Match> amountMatches = amountRegex.allMatches(textMessage);
  if (amountMatches.isNotEmpty) {
    Match amountMatch = amountMatches.first;
    amount = amountMatch.group(0);
  } else{
    amount = "";
  }

  // TODO: ISSUE: The app is not able to cast the string date we obtain from regex to date, that's why the date is in string here for now.
  // Extracting the date
  RegExp dateRegex = RegExp(bank.dateRegex);
  Iterable<Match> dateMatches = dateRegex.allMatches(textMessage);
  if (dateMatches.isNotEmpty) {
    Match dateMatch = dateMatches.first;
    // TODO: Below line has some issue
    // date = DateTime.parse(dateMatch.group(0)!);
    date = dateMatch.group(0);
    print(date);
  }

  // Extracting the action (debited or credited)
  RegExp actionRegex = RegExp(bank.transactionTypeRegex);
  Iterable<Match> actionMatches = actionRegex.allMatches(textMessage);
  if (actionMatches.isNotEmpty) {
    Match actionMatch = actionMatches.first;
    type = actionMatch.group(0)!;
  }

  TransacMessage transacMessage = TransacMessage(
      amount: amount, type: type, bank: bank.bankName, date: date
  );

  return transacMessage;
}