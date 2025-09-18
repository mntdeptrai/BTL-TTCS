import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Báo cáo công việc')),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final completed = taskProvider.tasks.where((t) => t.isCompleted).length;
          final total = taskProvider.tasks.length;
          final pending = total - completed;

          return Column(
            children: [
              // Biểu đồ tròn
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: completed.toDouble(),
                        color: Colors.green,
                        title: 'Hoàn thành ($completed)',
                        radius: 80,
                        titleStyle: TextStyle(color: Colors.white),
                      ),
                      PieChartSectionData(
                        value: pending.toDouble(),
                        color: Colors.red,
                        title: 'Đang chờ ($pending)',
                        radius: 80,
                        titleStyle: TextStyle(color: Colors.white),
                      ),
                    ],
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
              // Danh sách công việc hoàn thành
              Expanded(
                child: ListView.builder(
                  itemCount: taskProvider.tasks.where((t) => t.isCompleted).length,
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks.where((t) => t.isCompleted).toList()[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text('Hoàn thành: ${DateFormat('dd-MM-yyyy').format(task.dueDate)}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}