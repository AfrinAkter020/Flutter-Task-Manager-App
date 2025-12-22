import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'budget_screen.dart';
import 'models/task.dart';
import 'profile_screen.dart';
import 'task_detail_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TaskHome(),
    );
  }
}

class TaskHome extends StatefulWidget {
  const TaskHome({super.key});

  @override
  State<TaskHome> createState() => _TaskHomeState();
}

class _TaskHomeState extends State<TaskHome> {
  final List<Task> _tasks = <Task>[
    Task(
      id: '1',
      title: 'Plan weekly sprint',
      description: 'Outline priorities and milestones for the team.',
      category: 'Work',
      dueDate: DateTime.now().add(const Duration(hours: 6)),
    ),
    Task(
      id: '2',
      title: 'Buy groceries',
      description: 'Milk, eggs, vegetables, and snacks.',
      category: 'Personal',
      dueDate: DateTime.now().add(const Duration(days: 1, hours: 2)),
    ),
  ];

  final List<String> _categories = <String>[
    'Work',
    'Personal',
    'Shopping',
    'Learning',
  ];

  int _currentIndex = 0;

  void _addTask(Task task) {
    setState(() {
      _tasks.add(task);
      _currentIndex = 0;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Task added successfully')));
  }

  void _updateTaskCompletion(String taskId, bool isCompleted) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) return;
    setState(() {
      _tasks[index] = _tasks[index].copyWith(isCompleted: isCompleted);
    });
  }

  Future<void> _openTaskDetail(Task task) async {
    final updated = await Navigator.of(context).push<Task>(
      MaterialPageRoute<Task>(
        builder: (context) => TaskDetailScreen(task: task),
      ),
    );

    if (updated != null) {
      _updateTaskCompletion(updated.id, updated.isCompleted);
    }
  }

  void _onTabSelected(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      TasksScreen(
        tasks: _tasks,
        onTapTask: _openTaskDetail,
        onToggleComplete: _updateTaskCompletion,
      ),
      AddTaskScreen(categories: _categories, onCreate: _addTask),
      ProfileScreen(tasks: _tasks),
      const BudgetScreen(),
    ];

    const titles = <String>['Tasks', 'Add Task', 'Profile', 'Budget'];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_currentIndex])),
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Tasks'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
        ],
      ),
    );
  }
}

class TasksScreen extends StatelessWidget {
  const TasksScreen({
    super.key,
    required this.tasks,
    required this.onTapTask,
    required this.onToggleComplete,
  });

  final List<Task> tasks;
  final ValueChanged<Task> onTapTask;
  final void Function(String taskId, bool isCompleted) onToggleComplete;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks yet. Add your first one!'));
    }

    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (value) => onToggleComplete(task.id, value ?? false),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            '${task.category} • Due ${formatDueDate(task.dueDate)}',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onTapTask(task),
        );
      },
    );
  }
}
