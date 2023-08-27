

Banks sbiBank = Banks(
    bankName: "SBI",
    bankNameToSearchInMessage: "-SBI",
    amountRegex: r'Rs?\s?(\d+(:?\,\d+)?(\,\d+)?(\.\d{1,2}?))',
    transactionTypeRegex: r'debited|credited',
    dateRegex: r'\d{2}\w{3}\d{2}'
);

Banks axisBank = Banks(
    bankName: "Axis Bank",
    bankNameToSearchInMessage: "- Axis Bank",
    amountRegex: r'INR (\d+\.\d+)',
    transactionTypeRegex: r'Spent|Debit|Credit',
    dateRegex: r'(\d{2}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})'
);


// This has the template for regex to search in sms messages
class Banks{
  Banks({
    required this.bankName,
    required this.bankNameToSearchInMessage,
    required this.amountRegex,
    required this.transactionTypeRegex,
    required this.dateRegex
});
  final String bankName;
  final String bankNameToSearchInMessage;
  final String amountRegex;
  final String transactionTypeRegex;
  final String dateRegex;
}