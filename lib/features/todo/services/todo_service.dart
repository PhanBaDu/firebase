import 'package:firebase_database/firebase_database.dart';
import 'package:databases/features/todo/models/todo_model.dart';
import 'package:databases/features/authentication/services/auth_service.dart';

class TodoService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final AuthService _authService = AuthService();

  // Get current user ID
  String? get _currentUserId => _authService.currentUser?.uid;

  // Get todos reference for current user
  DatabaseReference get _todosRef => _database.child('todos').child(_currentUserId ?? '');

  // Stream todos for current user
  Stream<List<Todo>> getTodosStream() {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _todosRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      final List<Todo> todos = [];
      data.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          final todo = Todo.fromMap(Map<String, dynamic>.from(value));
          todos.add(todo);
        }
      });

      // Sort by creation date (newest first)
      todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return todos;
    });
  }

  // Add new todo
  Future<void> addTodo({
    required String title,
    required String description,
  }) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    final todoId = _todosRef.push().key;
    if (todoId == null) {
      throw Exception('Failed to generate todo ID');
    }

    final todo = Todo(
      id: todoId,
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
      userId: _currentUserId!,
    );

    await _todosRef.child(todoId).set(todo.toMap());
  }

  // Update todo
  Future<void> updateTodo(Todo todo) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    await _todosRef.child(todo.id).update(todo.toMap());
  }

  // Toggle todo completion
  Future<void> toggleTodoCompletion(Todo todo) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    final updatedTodo = todo.copyWith(
      isCompleted: !todo.isCompleted,
      completedAt: !todo.isCompleted ? DateTime.now() : null,
    );

    await _todosRef.child(todo.id).update(updatedTodo.toMap());
  }

  // Delete todo
  Future<void> deleteTodo(String todoId) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    await _todosRef.child(todoId).remove();
  }

  // Delete all completed todos
  Future<void> deleteCompletedTodos() async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    final snapshot = await _todosRef.get();
    final data = snapshot.value as Map<dynamic, dynamic>?;
    
    if (data != null) {
      final List<String> completedTodoIds = [];
      
      data.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          final todo = Todo.fromMap(Map<String, dynamic>.from(value));
          if (todo.isCompleted) {
            completedTodoIds.add(todo.id);
          }
        }
      });

      // Delete all completed todos
      for (final todoId in completedTodoIds) {
        await _todosRef.child(todoId).remove();
      }
    }
  }

  // Get todo by ID
  Future<Todo?> getTodoById(String todoId) async {
    if (_currentUserId == null) {
      return null;
    }

    final snapshot = await _todosRef.child(todoId).get();
    final data = snapshot.value as Map<dynamic, dynamic>?;
    
    if (data != null) {
      return Todo.fromMap(Map<String, dynamic>.from(data));
    }
    
    return null;
  }

  // Get todos count
  Stream<int> getTodosCountStream() {
    return getTodosStream().map((todos) => todos.length);
  }

  // Get completed todos count
  Stream<int> getCompletedTodosCountStream() {
    return getTodosStream().map((todos) => 
      todos.where((todo) => todo.isCompleted).length
    );
  }

  // Get pending todos count
  Stream<int> getPendingTodosCountStream() {
    return getTodosStream().map((todos) => 
      todos.where((todo) => !todo.isCompleted).length
    );
  }
} 