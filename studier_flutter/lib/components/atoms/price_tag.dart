import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Atom: Displays a formatted price tag with currency.
class PriceTag extends StatelessWidget {
  final double amount;
  final String currency;
  final String suffix;

  const PriceTag({
    super.key,
    required this.amount,
    this.currency = 'THB',
    this.suffix = '/hr',
  });

  @override
  Widget build(BuildContext context) {
    final String formatted = amount.toStringAsFixed(0);
    return Text(
      '฿$formatted$suffix',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }
}
