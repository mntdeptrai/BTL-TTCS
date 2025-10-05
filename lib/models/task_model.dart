class TaskModel {
  final String id; // Định danh duy nhất
  final String title; // Tiêu đề công việc
  final String description; // Mô tả chi tiết
  final String status; // Trạng thái công việc
  final int priority; // Độ ưu tiên
  final DateTime? dueDate; // Hạn hoàn thành
  final DateTime createdAt; // Thời gian tạo
  final DateTime updatedAt; // Thời gian cập nhật gần nhất
  final String? assignedTo; // ID người được giao
  final String createdBy; // ID người tạo
  final String? category; // Phân loại công việc
  final List<String>? attachments; // Danh sách link tài liệu đính kèm
  final bool completed; // Trạng thái hoàn thành

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.assignedTo,
    required this.createdBy,
    this.category,
    this.attachments,
    required this.completed,
  });

  // Chuyển đổi từ Map (Firestore) sang TaskModel
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      status: map['status']?.toString() ?? 'To do',
      priority: (map['priority'] as num?)?.toInt() ?? 1,
      dueDate: map['dueDate'] != null ? DateTime.tryParse(map['dueDate'] as String) : null,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime.now(),
      assignedTo: map['assignedTo']?.toString(),
      createdBy: map['createdBy']?.toString() ?? '',
      category: map['category']?.toString(),
      attachments: map['attachments'] != null ? List<String>.from(map['attachments']) : null,
      completed: map['completed'] as bool? ?? false,
    );
  }

  // Chuyển đổi từ TaskModel sang Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'assignedTo': assignedTo,
      'createdBy': createdBy,
      'category': category,
      'attachments': attachments,
      'completed': completed,
    };
  }
}