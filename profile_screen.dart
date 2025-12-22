import 'package:flutter/material.dart';
import 'models/task.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Alex Doe';
  String _role = 'Product Manager';
  bool _notificationsEnabled = true;
  bool _weeklySummary = true;

  int get _completedCount =>
      widget.tasks.where((task) => task.isCompleted).length;
  int get _pendingCount =>
      widget.tasks.where((task) => !task.isCompleted).length;

  void _openEditDialog() {
    final nameController = TextEditingController(text: _name);
    final roleController = TextEditingController(text: _role);

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _name = nameController.text.trim().isEmpty
                      ? _name
                      : nameController.text.trim();
                  _role = roleController.text.trim().isEmpty
                      ? _role
                      : roleController.text.trim();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = <String, String>{
      'Completed': _completedCount.toString(),
      'Pending': _pendingCount.toString(),
      'Total': widget.tasks.length.toString(),
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.indigo.shade100,
                child: const Icon(Icons.person, size: 40, color: Colors.indigo),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_name, style: Theme.of(context).textTheme.titleLarge),
                    Text(_role, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit profile'),
                      onPressed: _openEditDialog,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Task statistics',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stats.entries
                .map(
                  (entry) => Expanded(
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: <Widget>[
                            Text(
                              entry.value,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(entry.key),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          Text('Settings', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _notificationsEnabled,
            title: const Text('Enable notifications'),
            subtitle: const Text('Get alerts for upcoming tasks'),
            onChanged: (value) => setState(() => _notificationsEnabled = value),
          ),
          SwitchListTile(
            value: _weeklySummary,
            title: const Text('Send weekly summary'),
            subtitle: const Text('Email recap of completed tasks'),
            onChanged: (value) => setState(() => _weeklySummary = value),
          ),
          const SizedBox(height: 24),
          Text('About', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Track your tasks, plan ahead, and stay productive. Customize your settings and keep your profile up to date.',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
