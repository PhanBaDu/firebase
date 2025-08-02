import 'package:flutter/foundation.dart';
import 'package:databases/features/todo/models/todo_model.dart';
import 'package:databases/features/todo/services/firestore_todo_service.dart';

class FirestoreTodoProvider extends ChangeNotifier {
  final FirestoreTodoService _todoService = FirestoreTodoService();
  
  List<Todo> _todos = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Computed getters
  List<Todo> get completedTodos => _todos.where((todo) => todo.isCompleted).toList();
  List<Todo> get pendingTodos => _todos.where((todo) => !todo.isCompleted).toList();
  int get totalTodos => _todos.length;
  int get completedCount => completedTodos.length;
  int get pendingCount => pendingTodos.length;

  // Initialize provider
  void initialize() {
    _loadTodos();
  }

  // Load todos from Firestore
  void _loadTodos() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _todoService.getTodosStream().listen(
      (todos) {
        _todos = todos;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  // Add new todo
  Future<void> addTodo({
    required String title,
    required String description,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _todoService.addTodo(
        title: title,
        description: description,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Update todo
  Future<void> updateTodo(Todo todo) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _todoService.updateTodo(todo);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Toggle todo completion
  Future<void> toggleTodoCompletion(Todo todo) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _todoService.toggleTodoCompletion(todo);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Delete todo
  Future<void> deleteTodo(String todoId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _todoService.deleteTodo(todoId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Delete all completed todos
  Future<void> deleteCompletedTodos() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _todoService.deleteCompletedTodos();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh todos
  void refreshTodos() {
    _loadTodos();
  }
} 