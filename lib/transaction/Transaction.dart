import 'package:budget_tracker/category/Category.dart';
import 'package:intl/intl.dart';

class Transaction {
  final int id;
  final String type;
  final TransactionCategory category;
  final double amount;
  final DateTime dateTime;
  final String note;

  Transaction(
      {this.id,
      this.type,
      this.category,
      this.amount,
      this.dateTime,
      this.note});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        id: json['id'],
        type: json['type'],
        amount: json['amount'],
        dateTime: DateFormat('yyyy-MM-dd').parse(json['date']),
        note: json['note'],
        category: TransactionCategory.fromJson(json['category']));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'category': {'category': category.category, 'id': category.id},
        'amount': amount,
        'date': DateFormat('yyyy-MM-dd').format(dateTime),
        'note': note
      };
}
