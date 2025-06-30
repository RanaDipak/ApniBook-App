class Transaction {
  final String id;
  final String clientId;
  final DateTime dateTime;
  final int received;
  final int paid;

  Transaction({
    required this.id,
    required this.clientId,
    required this.dateTime,
    required this.received,
    required this.paid,
  });
}
