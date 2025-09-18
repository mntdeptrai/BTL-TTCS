import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart'; // Thêm để tạo id mới
import '../model/task.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task; // Tham số task có thể là null

  const AddTaskScreen({super.key, this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
      _selectedDate = widget.task!.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Thêm công việc' : 'Sửa công việc')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Tiêu đề'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
            ),
            ListTile(
              title: Text(DateFormat('dd-MM-yyyy').format(_selectedDate)),
              trailing: const Icon(Icons.edit),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (date != null) setState(() => _selectedDate = date);
              },
            ),
            ElevatedButton(
              onPressed: () {
                final task = Task(
                  id: widget.task?.id ?? const Uuid().v4(), // Tạo id mới nếu null
                  title: _titleController.text,
                  description: _descController.text,
                  dueDate: _selectedDate,
                  isCompleted: widget.task?.isCompleted ?? false,
                );
                if (widget.task == null) {
                  Provider.of<TaskProvider>(context, listen: false).addTask(task);
                } else {
                  final updatedTask = Task(
                    id: widget.task!.id, // Sử dụng id hiện tại khi sửa
                    title: _titleController.text,
                    description: _descController.text,
                    dueDate: _selectedDate,
                    isCompleted: widget.task!.isCompleted,
                  );
                  Provider.of<TaskProvider>(context, listen: false).updateTask(updatedTask);
                }
                Navigator.pop(context);
              },
              child: Text(widget.task == null ? 'Thêm' : 'Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }
}