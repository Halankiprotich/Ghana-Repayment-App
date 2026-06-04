import 'package:flutter/material.dart';

class RepaymentLink {
  final int id;
  final String linkToken;
  final String repaymentUrl;
  final String loanReference;
  final String borrowerName;
  final String? borrowerPhone;
  final String? borrowerEmail;
  final double totalAmount;
  final String networkName;
  final String status;
  final String? dueDate;
  final String? createdAt;

  RepaymentLink({
    required this.id,
    required this.linkToken,
    required this.repaymentUrl,
    required this.loanReference,
    required this.borrowerName,
    this.borrowerPhone,
    this.borrowerEmail,
    required this.totalAmount,
    required this.networkName,
    required this.status,
    this.dueDate,
    this.createdAt,
  });

  factory RepaymentLink.fromJson(Map<String, dynamic> json) {
    return RepaymentLink(
      id: json['id'] ?? 0,
      linkToken: json['linkToken'] ?? '',
      repaymentUrl: json['repaymentUrl'] ?? '',
      loanReference: json['loanReference'] ?? '',
      borrowerName: json['borrowerName'] ?? '',
      borrowerPhone: json['borrowerPhone'],
      borrowerEmail: json['borrowerEmail'],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      networkName: json['networkName'] ?? '',
      status: json['status'] ?? 'PENDING',
      dueDate: json['dueDate'],
      createdAt: json['createdAt'],
    );
  }

  bool get isPending => status == 'PENDING';
  bool get isPaid => status == 'PAID';
  bool get isExpired => status == 'EXPIRED';

  Color get statusColor {
    if (isPending) return Colors.orange;
    if (isPaid) return Colors.green;
    return Colors.red;
  }
}