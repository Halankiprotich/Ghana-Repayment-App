import 'package:flutter/material.dart';
import '../models/link.dart';

class LinkCard extends StatelessWidget {
  final RepaymentLink link;
  final VoidCallback onTap;
  final VoidCallback? onMarkPaid;
  final VoidCallback? onCancel;

  const LinkCard({
    super.key,
    required this.link,
    required this.onTap,
    this.onMarkPaid,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      link.loanReference,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: link.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      link.status,
                      style: TextStyle(
                        color: link.statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    link.borrowerName,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.network_cell, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    link.networkName,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GHS ${link.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF006B3F),
                    ),
                  ),
                  if (link.isPending) ...[
                    if (onMarkPaid != null)
                      TextButton(
                        onPressed: onMarkPaid,
                        child: const Text('Mark Paid'),
                      ),
                    if (onCancel != null)
                      TextButton(
                        onPressed: onCancel,
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Cancel'),
                      ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}