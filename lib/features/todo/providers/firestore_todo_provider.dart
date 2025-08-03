import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:databases/features/todo/models/todo_model.dart';
import 'package:databases/features/todo/services/firestore_todo_service.dart';

class FirestoreTodoProvider extends ChangeNotifier {
  final FirestoreTodoService _todoService = FirestoreTodoService();
  
  List<Todo> _todos = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<Todo>>? _todosSubscription;

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
    print('FirestoreTodoProvider: Initializing...'); // Debug log
    _loadTodos();
  }

  // Load todos from Firestore
  void _loadTodos() {
    print('FirestoreTodoProvider: Loading todos...'); // Debug log
    
    // Cancel existing subscription if any
    _todosSubscription?.cancel();
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    _todosSubscription = _todoService.getTodosStream().listen(
      (todos) {
        print('FirestoreTodoProvider: Received ${todos.length} todos'); // Debug log
        print('FirestoreTodoProvider: Todos: ${todos.map((t) => '${t.title} (${t.id})').toList()}'); // Debug log
        _todos = todos;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        print('FirestoreTodoProvider: Error loading todos: $error'); // Debug log
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
    print('FirestoreTodoProvider: Starting addTodo...'); // Debug log
    print('FirestoreTodoProvider: Title: $title, Description: $description'); // Debug log
    
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('FirestoreTodoProvider: Calling _todoService.addTodo...'); // Debug log
      await _todoService.addTodo(
        title: title,
        description: description,
      );

      print('FirestoreTodoProvider: Todo added successfully!'); // Debug log
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('FirestoreTodoProvider: Error adding todo: $e'); // Debug log
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

      // Update local state immediately for better UX
      final index = _todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        _todos[index] = todo.copyWith(
          isCompleted: !todo.isCompleted,
          completedAt: !todo.isCompleted ? DateTime.now() : null,
        );
        notifyListeners();
      }

      await _todoService.toggleTodoCompletion(todo);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // If error, reload to restore correct state
      _loadTodos();
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

      // Remove from local state immediately for better UX
      _todos.removeWhere((todo) => todo.id == todoId);
      notifyListeners();

      await _todoService.deleteTodo(todoId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // If error, reload to restore correct state
      _loadTodos();
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

  // Debug method to check current state
  void debugState() {
    print('FirestoreTodoProvider Debug State:');
    print('- IsLoading: $_isLoading');
    print('- Error: $_error');
    print('- Todos count: ${_todos.length}');
    print('- Todos: ${_todos.map((t) => '${t.title} (${t.id})').toList()}');
    print('- Subscription active: ${_todosSubscription != null}');
  }

  // Debug method to load all todos without user filter
  void loadAllTodos() {
    print('FirestoreTodoProvider: Loading ALL todos...'); // Debug log
    
    // Cancel existing subscription if any
    _todosSubscription?.cancel();
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    _todosSubscription = _todoService.getAllTodosStream().listen(
      (todos) {
        print('FirestoreTodoProvider: Received ${todos.length} ALL todos'); // Debug log
        _todos = todos;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        print('FirestoreTodoProvider: Error loading ALL todos: $error'); // Debug log
        _isLoading = false;
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _todosSubscription?.cancel();
    super.dispose();
  }
} 