import 'package:flutter/material.dart';
import 'widgets/task_card.dart';
import 'widgets/stat_item.dart';

// Main entry point of the application
void main() {
  runApp(const TaskManagerApp());
}

// Root widget of the app
class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Task Manager',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: const HomeScreen(),
    );
  }
}

// Task model to represent a single task
class Task {
  String title;
  String description;
  String category;
  String priority;
  String dueTime;
  Color categoryColor;
  bool isCompleted;
  bool isFavorite;

  Task({
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueTime,
    required this.categoryColor,
    this.isCompleted = false,
    this.isFavorite = false,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List to store all tasks
  List<Task> tasks = [
    Task(
      title: 'Complete Flutter Lab',
      description: 'Build UI components and understand widgets',
      category: 'Study',
      priority: 'High',
      dueTime: '10:00 AM',
      categoryColor: Colors.green,
    ),
    Task(
      title: 'Team Meeting',
      description: 'Weekly sync with development team',
      category: 'Work',
      priority: 'Medium',
      dueTime: '2:30 PM',
      categoryColor: Colors.blue,
    ),
    Task(
      title: 'Buy Groceries',
      description: 'Milk, Eggs, Bread, Fruits',
      category: 'Personal',
      priority: 'Low',
      dueTime: '6:00 PM',
      categoryColor: Colors.orange,
    ),
  ];

  // Current filter status
  String filterStatus = 'All';

  // Get filtered tasks based on current filter
  List<Task> get filteredTasks {
    if (filterStatus == 'Pending') {
      return tasks.where((task) => !task.isCompleted).toList();
    } else if (filterStatus == 'Completed') {
      return tasks.where((task) => task.isCompleted).toList();
    }
    return tasks;
  }

  // Calculate statistics
  int get totalTasks => tasks.length;
  int get pendingTasks => tasks.where((task) => !task.isCompleted).length;
  int get completedTasks => tasks.where((task) => task.isCompleted).length;

  // Show dialog to add a new task
  void _addTask() {
    // Controllers for text inputs
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final timeController = TextEditingController();

    // Default values for dropdowns
    String selectedCategory = 'Study';
    String selectedPriority = 'Medium';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Study', 'Work', 'Personal'].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  items: ['High', 'Medium', 'Low'].map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedPriority = value!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: 'Due Time (e.g., 10:00 AM)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate that title is not empty
                if (titleController.text.isNotEmpty) {
                  // Determine color based on category
                  Color taskColor;
                  if (selectedCategory == 'Study') {
                    taskColor = Colors.green;
                  } else if (selectedCategory == 'Work') {
                    taskColor = Colors.blue;
                  } else {
                    taskColor = Colors.orange;
                  }

                  setState(() {
                    tasks.add(
                      Task(
                        title: titleController.text,
                        description: descriptionController.text,
                        category: selectedCategory,
                        priority: selectedPriority,
                        dueTime: timeController.text,
                        categoryColor: taskColor,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with search functionality
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search tasks...',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
            ),
          ),
        ),
      ),

      // Main body with task list
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Page title
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              "Today's Tasks",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),

          // Filter Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterButton('All'),
              _buildFilterButton('Pending'),
              _buildFilterButton('Completed'),
            ],
          ),

          const SizedBox(height: 16),

          // Display all tasks
          ...filteredTasks.map((task) {
            int index = tasks.indexOf(task);
            return Dismissible(
              key: Key(task.title + index.toString()),
              background: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete, color: Colors.white, size: 32),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                // Remove task from list
                setState(() {
                  tasks.removeAt(index);
                });
                // Show confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${task.title} deleted')),
                );
              },
              child: TaskCard(
                title: task.title,
                description: task.description,
                category: task.category,
                priority: task.priority,
                dueTime: task.dueTime,
                categoryColor: task.categoryColor,
                isCompleted: task.isCompleted,
                onTap: () {
                  // Toggle completion status
                  setState(() {
                    task.isCompleted = !task.isCompleted;
                  });
                },
                onDelete: () {
                  // Delete task
                  setState(() {
                    tasks.removeAt(index);
                  });
                },
              ),
            );
          }).toList(),

          // Statistics display at bottom
          Container(
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color.fromARGB(255, 209, 202, 202),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatItem(
                  count: totalTasks.toString(),
                  label: 'Total',
                  color: Colors.blue,
                ),
                StatItem(
                  count: pendingTasks.toString(),
                  label: 'Pending',
                  color: Colors.orange,
                ),
                StatItem(
                  count: completedTasks.toString(),
                  label: 'Completed',
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),

      // Add button to create new tasks
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  // Helper method to build filter buttons
  Widget _buildFilterButton(String filter) {
    bool isSelected = filterStatus == filter;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          filterStatus = filter;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(filter),
    );
  }
}
