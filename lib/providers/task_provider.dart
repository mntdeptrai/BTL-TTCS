import 'package:flutter/foundation.dart';
import '../model/task.dart'; // Đảm bảo đường dẫn import đúng

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = []; // Đánh dấu final

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task); // Xóa if (task != null) vì task là required
    notifyListeners();
  }

  void toggleTask(String? id) {
    if (id != null) {
      final task = _tasks.firstWhere((t) => t.id == id, orElse: () => throw Exception('Task not found'));
      task.isCompleted = !task.isCompleted;
      notifyListeners();
    }
  }

  void updateTask(Task? updatedTask) {
    if (updatedTask != null) {
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    }
  }

  void deleteTask(String? id) {
    if (id != null) {
      _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
    }
  }
}