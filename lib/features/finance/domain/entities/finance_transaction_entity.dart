class FinanceTransactionEntity {
  final int id;
  final String projectName;
  final String category;
  final String description;
  final double amount;
  final String date;
  final String type; // 'income', 'expense'

  const FinanceTransactionEntity({
    required this.id,
    required this.projectName,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
  });
}
