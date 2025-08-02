# Firebase Authentication Errors - Hướng dẫn xử lý lỗi

## Lỗi "the supplied auth credential is malformed or has expired"

### Nguyên nhân gây lỗi:

1. **Credential bị hỏng (malformed)**:
   - Token không đúng định dạng
   - Dữ liệu credential bị corrupt
   - Lỗi trong quá trình mã hóa/giải mã

2. **Credential đã hết hạn (expired)**:
   - Token đã quá thời gian sử dụng
   - Session timeout
   - Token refresh thất bại

3. **Vấn đề cấu hình Firebase**:
   - Cấu hình Firebase không đúng
   - API key không hợp lệ
   - Project ID không đúng

4. **Vấn đề mạng**:
   - Kết nối internet không ổn định
   - Timeout khi gọi API
   - DNS resolution issues

### Cách khắc phục:

#### 1. Kiểm tra cấu hình Firebase
```dart
// Đảm bảo firebase_options.dart được cấu hình đúng
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

#### 2. Xử lý lỗi trong code
```dart
try {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
} on FirebaseAuthException catch (e) {
  switch (e.code) {
    case 'invalid-credential':
      // Thử refresh token hoặc đăng nhập lại
      await _handleCredentialError();
      break;
    case 'network-request-failed':
      // Kiểm tra kết nối mạng
      break;
    // Xử lý các lỗi khác...
  }
}
```

#### 3. Refresh Token
```dart
Future<void> refreshToken() async {
  try {
    await currentUser?.getIdToken(true);
  } catch (e) {
    // Token không thể refresh, yêu cầu đăng nhập lại
    await signOut();
  }
}
```

#### 4. Kiểm tra kết nối mạng
```dart
Future<bool> checkConnection() async {
  try {
    await FirebaseAuth.instance.currentUser?.reload();
    return true;
  } catch (e) {
    return false;
  }
}
```

### Các lỗi Firebase Auth phổ biến khác:

| Error Code | Mô tả | Cách khắc phục |
|------------|-------|----------------|
| `invalid-credential` | Credential không hợp lệ hoặc hết hạn | Refresh token hoặc đăng nhập lại |
| `user-not-found` | Không tìm thấy user | Kiểm tra email đúng |
| `wrong-password` | Mật khẩu sai | Kiểm tra lại mật khẩu |
| `email-already-in-use` | Email đã được sử dụng | Sử dụng email khác |
| `weak-password` | Mật khẩu quá yếu | Tăng độ mạnh mật khẩu |
| `invalid-email` | Email không hợp lệ | Kiểm tra định dạng email |
| `too-many-requests` | Quá nhiều request | Chờ một lúc rồi thử lại |
| `network-request-failed` | Lỗi mạng | Kiểm tra kết nối internet |
| `user-disabled` | Tài khoản bị vô hiệu | Liên hệ admin |
| `operation-not-allowed` | Phương thức không được phép | Kiểm tra cấu hình Firebase |

### Best Practices:

1. **Luôn xử lý lỗi**: Sử dụng try-catch để bắt tất cả lỗi
2. **Hiển thị thông báo rõ ràng**: Giúp user hiểu vấn đề
3. **Tự động retry**: Thử lại với lỗi tạm thời
4. **Log lỗi**: Ghi log để debug
5. **Graceful degradation**: Xử lý khi không có internet

### Debug Tips:

1. **Kiểm tra Firebase Console**: Xem logs và errors
2. **Test với Firebase CLI**: Sử dụng Firebase CLI để test
3. **Kiểm tra Network**: Sử dụng DevTools để xem network requests
4. **Validate Configuration**: Đảm bảo cấu hình đúng

### Ví dụ xử lý lỗi hoàn chỉnh:

```dart
class AuthService {
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          // Thử refresh token
          await _tryRefreshToken();
          // Nếu vẫn lỗi, throw exception
          rethrow;
        case 'network-request-failed':
          throw AuthException('Lỗi kết nối mạng');
        default:
          rethrow;
      }
    }
  }

  Future<void> _tryRefreshToken() async {
    try {
      await FirebaseAuth.instance.currentUser?.getIdToken(true);
    } catch (e) {
      // Token không thể refresh
      await FirebaseAuth.instance.signOut();
    }
  }
}
``` 