import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'add_task_screen.dart';
import 'report_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý công việc')),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) => taskProvider.toggleTask(task.id),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddTaskScreen(task: task)),
                ),
                onLongPress: () => taskProvider.deleteTask(task.id),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskScreen())),
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'report',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReportScreen())),
            child: Icon(Icons.bar_chart),
          ),
        ],
      ),
    );
  }
}