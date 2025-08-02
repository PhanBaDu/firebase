import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Xử lý lỗi chi tiết hơn
      switch (e.code) {
        case 'invalid-credential':
        case 'invalid-email':
        case 'wrong-password':
        case 'user-not-found':
        case 'user-disabled':
        case 'too-many-requests':
        case 'operation-not-allowed':
        case 'network-request-failed':
          rethrow; // Để UI xử lý
        default:
          throw FirebaseAuthException(
            code: 'unknown-error',
            message: 'Đã xảy ra lỗi không xác định: ${e.message}',
          );
      }
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'Đã xảy ra lỗi không xác định: $e',
      );
    }
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      return await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Xử lý lỗi chi tiết hơn
      switch (e.code) {
        case 'weak-password':
        case 'email-already-in-use':
        case 'invalid-email':
        case 'operation-not-allowed':
        case 'too-many-requests':
        case 'network-request-failed':
          rethrow; // Để UI xử lý
        default:
          throw FirebaseAuthException(
            code: 'unknown-error',
            message: 'Đã xảy ra lỗi không xác định: ${e.message}',
          );
      }
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'Đã xảy ra lỗi không xác định: $e',
      );
    }
  }

  Future<void> signOut() async {
    try {
      print('Starting signOut...'); // Debug log
      await firebaseAuth.signOut();
      print('SignOut completed successfully'); // Debug log
    } catch (e) {
      print('SignOut error: $e'); // Debug log
      throw FirebaseAuthException(
        code: 'sign-out-failed',
        message: 'Không thể đăng xuất: $e',
      );
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
        case 'user-not-found':
        case 'too-many-requests':
        case 'network-request-failed':
          rethrow;
        default:
          throw FirebaseAuthException(
            code: 'reset-password-failed',
            message: 'Không thể gửi email reset password: ${e.message}',
          );
      }
    }
  }

  Future<void> updateUsername({required String username}) async {
    try {
      await currentUser!.updateDisplayName(username);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'update-username-failed',
        message: 'Không thể cập nhật tên người dùng: $e',
      );
    }
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.delete();
      await signOut();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
        case 'requires-recent-login':
          rethrow;
        default:
          throw FirebaseAuthException(
            code: 'delete-account-failed',
            message: 'Không thể xóa tài khoản: ${e.message}',
          );
      }
    }
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String email,
    required String newPassword,
  }) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'weak-password':
        case 'requires-recent-login':
          rethrow;
        default:
          throw FirebaseAuthException(
            code: 'reset-password-failed',
            message: 'Không thể đổi mật khẩu: ${e.message}',
          );
      }
    }
  }

  // Thêm method để kiểm tra trạng thái kết nối
  Future<bool> checkConnection() async {
    try {
      await firebaseAuth.currentUser?.reload();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Thêm method để refresh token
  Future<void> refreshToken() async {
    try {
      await currentUser?.getIdToken(true);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'token-refresh-failed',
        message: 'Không thể làm mới token: $e',
      );
    }
  }
}
