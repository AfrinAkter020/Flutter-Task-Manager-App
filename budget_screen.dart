import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  double _totalBudget = 5000.0;
  double _spent = 1250.0;

  final List<Map<String, dynamic>> _expenses = [
    {'name': 'Groceries', 'amount': 450.0, 'category': 'Food'},
    {'name': 'Transport', 'amount': 300.0, 'category': 'Travel'},
    {'name': 'Utilities', 'amount': 500.0, 'category': 'Bills'},
  ];

  double get _remaining => _totalBudget - _spent;
  double get _percentUsed => (_spent / _totalBudget * 100).clamp(0, 100);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Budget Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Budget'),
                          Text(
                            '\$${_totalBudget.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Spent'),
                          Text(
                            '\$${_spent.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: _percentUsed / 100,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _percentUsed > 80 ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Remaining: \$${_remaining.toStringAsFixed(0)} (${(100 - _percentUsed).toStringAsFixed(0)}%)',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Recent Expenses',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _expenses.length,
            itemBuilder: (context, index) {
              final expense = _expenses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade100,
                    child: const Icon(Icons.attach_money, color: Colors.indigo),
                  ),
                  title: Text(expense['name']),
                  subtitle: Text(expense['category']),
                  trailing: Text(
                    '\$${expense['amount'].toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
