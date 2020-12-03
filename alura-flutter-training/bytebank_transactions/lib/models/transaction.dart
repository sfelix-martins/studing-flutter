class Transaction {
  final double value;
  final int accountNumber;

  Transaction(
    this.value,
    this.accountNumber,
  );

  @override
  String toString() {
    return 'Transaction{value: $value, accountNumber: $accountNumber}';
  }
}
