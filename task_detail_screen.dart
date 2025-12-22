import 'package:flutter/material.dart';
import 'models/task.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key, required this.task});

  final Task task;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.task.isCompleted;
  }

  Future<bool> _handlePop() async {
    Navigator.of(context).pop(widget.task.copyWith(isCompleted: _isCompleted));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handlePop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handlePop,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.task.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Chip(label: Text(widget.task.category)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Due ${formatDueDate(widget.task.dueDate)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(widget.task.description),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Mark as completed'),
                value: _isCompleted,
                onChanged: (value) => setState(() => _isCompleted = value),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(
                    _isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                  ),
                  label: Text(_isCompleted ? 'Completed' : 'Mark complete'),
                  onPressed: () => setState(() => _isCompleted = !_isCompleted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
