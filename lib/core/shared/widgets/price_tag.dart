import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';

class PriceTag extends StatelessWidget {
  final double amount;
  final bool isPaid;

  const PriceTag({super.key, required this.amount, this.isPaid = true});

  @override
  Widget build(BuildContext context) {
    final style = isPaid ? AppTextStyles.pricePaid() : AppTextStyles.priceFree();
    final label = isPaid ? '${amount.toInt()} FCFA' : 'Gratuit';
    return Text(label, style: style);
  }
}
