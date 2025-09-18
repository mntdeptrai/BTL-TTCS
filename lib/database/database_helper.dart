import 'package:mssql_connection/mssql_connection.dart';
import '../models/task.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static MssqlConnection? _connection;

  DatabaseHelper._init();

  Future<void> init() async {
    try {
      _connection = await MssqlConnection.fromConfig(
        Config(
          host: 'localhost',
          port: 1433,
          database: 'TaskManager',
          username: 'sa',
          password: 'Mnt@2004',
          encryption: EncryptionOption.OFF, // Vô hiệu hóa mã hóa cho localhost
        ),
      );
      print("Connected to SQL Server successfully!");
    } catch (e) {
      print("Error connecting to SQL Server: $e");
    }
  }

  Future<void> disconnect() async {
    await _connection?.close();
  }

  Future<void> insertUser(User user) async {
    await _connection?.query(
      "INSERT INTO Users (Username, Password, Role) VALUES (@username, @password, @role)",
      {'@username': user.username, '@password': user.password, '@role': user.role},
    );
  }

  Future<User?> getUser(String username, String password) async {
    final results = await _connection?.query(
      "SELECT * FROM Users WHERE Username = @username AND Password = @password",
      {'@username': username, '@password': password},
    );
    if (results != null && results.isNotEmpty) {
      return User.fromMap(results.first.toColumnMap());
    }
    return null;
  }

  Future<List<User>> getUsers() async {
    final results = await _connection?.query("SELECT * FROM Users");
    if (results != null) {
      return results.map((row) => User.fromMap(row.toColumnMap())).toList();
    }
    return [];
  }

  Future<void> insertTask(Task task) async {
    await _connection?.query(
      "INSERT INTO Tasks (Title, Description, DueDate, Status, UserId) VALUES (@title, @description, @dueDate, @status, @userId)",
      {
        '@title': task.title,
        '@description': task.description,
        '@dueDate': task.dueDate,
        '@status': task.status,
        '@userId': task.userId,
      },
    );
  }

  Future<List<Task>> getTasks(int? userId, String role) async {
    String query = role == 'Admin'
        ? "SELECT * FROM Tasks"
        : "SELECT * FROM Tasks WHERE UserId = @userId";
    final results = await _connection?.query(query, {'@userId': userId});
    if (results != null) {
      return results.map((row) => Task.fromMap(row.toColumnMap())).toList();
    }
    return [];
  }

  Future<void> updateTask(Task task) async {
    await _connection?.query(
      "UPDATE Tasks SET Title = @title, Description = @description, DueDate = @dueDate, Status = @status, UserId = @userId WHERE Id = @id",
      {
        '@id': task.id,
        '@title': task.title,
        '@description': task.description,
        '@dueDate': task.dueDate,
        '@status': task.status,
        '@userId': task.userId,
      },
    );
  }

  Future<void> deleteTask(int id) async {
    await _connection?.query("DELETE FROM Tasks WHERE Id = @id", {'@id': id});
  }

  Future<List<Task>> getTasksByStatus(String status, int? userId, String role) async {
    String query = role == 'Admin'
        ? "SELECT * FROM Tasks WHERE Status = @status"
        : "SELECT * FROM Tasks WHERE Status = @status AND UserId = @userId";
    final results = await _connection?.query(query, {'@status': status, '@userId': userId});
    if (results != null) {
      return results.map((row) => Task.fromMap(row.toColumnMap())).toList();
    }
    return [];
  }
}