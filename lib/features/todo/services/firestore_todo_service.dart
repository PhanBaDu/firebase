import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:databases/features/todo/models/todo_model.dart';
import 'package:databases/features/authentication/services/auth_service.dart';

class FirestoreTodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  // Get current user ID
  String? get _currentUserId {
    final userId = _authService.currentUser?.uid;
    print('FirestoreTodoService: Current user ID: $userId'); // Debug log
    return userId;
  }

  // Get todos collection
  CollectionReference<Map<String, dynamic>> get _todosCollection => 
      _firestore.collection('todos');

  // Stream todos for current user
  Stream<List<Todo>> getTodosStream() {
    print('FirestoreTodoService: Getting todos stream...'); // Debug log
    print('FirestoreTodoService: Current user ID: $_currentUserId'); // Debug log
    
    if (_currentUserId == null) {
      print('FirestoreTodoService: No user ID, returning empty stream'); // Debug log
      return Stream.value([]);
    }

    print('FirestoreTodoService: Creating stream for user: $_currentUserId'); // Debug log
    return _todosCollection
        .where('userId', isEqualTo: _currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          print('FirestoreTodoService: Received ${snapshot.docs.length} todos from Firestore'); // Debug log
          print('FirestoreTodoService: Document IDs: ${snapshot.docs.map((doc) => doc.id).toList()}'); // Debug log
          return snapshot.docs.map((doc) {
            final data = doc.data();
            print('FirestoreTodoService: Document data: $data'); // Debug log
            return Todo.fromMap({
              ...data,
              'id': doc.id,
            });
          }).toList();
        });
  }

  // Add new todo
  Future<void> addTodo({
    required String title,
    required String description,
  }) async {
    print('FirestoreTodoService: Starting addTodo...'); // Debug log
    print('FirestoreTodoService: Current user ID: $_currentUserId'); // Debug log
    
    if (_currentUserId == null) {
      print('FirestoreTodoService: User not authenticated!'); // Debug log
      throw Exception('User not authenticated');
    }

    final todo = Todo(
      id: '', // Will be set by Firestore
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
      userId: _currentUserId!,
    );

    print('FirestoreTodoService: Todo object created: ${todo.toMap()}'); // Debug log

    try {
      final docRef = await _todosCollection.add(todo.toMap());
      print('FirestoreTodoService: Todo added successfully with ID: ${docRef.id}'); // Debug log
    } catch (e) {
      print('FirestoreTodoService: Error adding todo: $e'); // Debug log
      rethrow;
    }
  }

  // Update todo
  Future<void> updateTodo(Todo todo) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    await _todosCollection.doc(todo.id).update(todo.toMap());
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

    await _todosCollection.doc(todo.id).update(updatedTodo.toMap());
  }

  // Delete todo
  Future<void> deleteTodo(String todoId) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    await _todosCollection.doc(todoId).delete();
  }

  // Delete all completed todos
  Future<void> deleteCompletedTodos() async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    final snapshot = await _todosCollection
        .where('userId', isEqualTo: _currentUserId)
        .where('isCompleted', isEqualTo: true)
        .get();

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // Get todo by ID
  Future<Todo?> getTodoById(String todoId) async {
    if (_currentUserId == null) {
      return null;
    }

    final doc = await _todosCollection.doc(todoId).get();
    if (doc.exists) {
      final data = doc.data()!;
      return Todo.fromMap({
        ...data,
        'id': doc.id,
      });
    }
    return null;
  }

  // Get todos count
  Stream<int> getTodosCountStream() {
    return getTodosStream().map((todos) => todos.length);
  }

  // Debug method to check all todos without user filter
  Stream<List<Todo>> getAllTodosStream() {
    print('FirestoreTodoService: Getting ALL todos (no user filter)...'); // Debug log
    return _todosCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          print('FirestoreTodoService: Received ${snapshot.docs.length} ALL todos from Firestore'); // Debug log
          return snapshot.docs.map((doc) {
            final data = doc.data();
            print('FirestoreTodoService: ALL todo data: $data'); // Debug log
            return Todo.fromMap({
              ...data,
              'id': doc.id,
            });
          }).toList();
        });
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