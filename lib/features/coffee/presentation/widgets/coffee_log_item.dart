import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_demo/features/coffee/domain/entities/coffee_log.dart';

class CoffeeLogItem extends StatelessWidget {
  final CoffeeLog coffeeLog;

  const CoffeeLogItem({
    super.key,
    required this.coffeeLog,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormatter = DateFormat('h:mm a');
    final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.coffee,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coffee',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    timeFormatter.format(coffeeLog.timestamp),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            Text(
              currencyFormatter.format(coffeeLog.price),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
} 