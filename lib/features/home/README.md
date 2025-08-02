# Home Feature

Cấu trúc thư mục cho tính năng Home của ứng dụng.

## 📁 Cấu trúc thư mục

```
lib/features/home/
├── README.md                    # Tài liệu này
├── index.dart                   # Export tất cả components
├── constants/                   # Constants và theme
│   ├── app_colors.dart         # Màu sắc của app
│   └── app_sizes.dart          # Kích thước và spacing
├── screens/                     # Các màn hình chính
│   ├── home_screen.dart        # Màn hình chính với navigation
│   ├── home_tab.dart           # Tab Home
│   └── my_profile_tab.dart     # Tab My Profile
└── widgets/                     # Widgets tái sử dụng
    ├── profile_header.dart     # Header của profile
    ├── profile_menu_item.dart  # Menu item trong profile
    └── welcome_card.dart       # Card chào mừng
```

## 🎯 Các Components

### Screens
- **HomeScreen**: Màn hình chính với CupertinoTabScaffold
- **HomeTab**: Tab hiển thị trang chủ với welcome card và quick actions
- **MyProfileTab**: Tab hiển thị thông tin user và các tùy chọn

### Widgets
- **ProfileHeader**: Widget hiển thị thông tin user (avatar, email, member since)
- **ProfileMenuItem**: Widget cho menu item với icon, title và chevron
- **WelcomeCard**: Widget card chào mừng với icon, title và subtitle

### Constants
- **AppColors**: Tất cả màu sắc được sử dụng trong app
- **AppSizes**: Tất cả kích thước, padding, font size

## 🚀 Cách sử dụng

### Import
```dart
import 'package:databases/features/home/index.dart';
```

### Sử dụng HomeScreen
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: const HomeScreen(),
    );
  }
}
```

### Sử dụng Widgets
```dart
// Profile Header
ProfileHeader(user: currentUser)

// Profile Menu Item
ProfileMenuItem(
  icon: CupertinoIcons.settings,
  title: 'Cài đặt',
  onPressed: () => handleSettings(),
)

// Welcome Card
WelcomeCard(
  title: 'Chào mừng!',
  subtitle: 'Đây là trang chủ của bạn',
  icon: CupertinoIcons.house_fill,
)
```

### Sử dụng Constants
```dart
// Colors
Container(
  color: AppColors.cardBackground,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textPrimary),
  ),
)

// Sizes
Container(
  padding: EdgeInsets.all(AppSizes.paddingLarge),
  child: Icon(
    CupertinoIcons.home,
    size: AppSizes.iconLarge,
  ),
)
```

## 🔧 Tính năng

### HomeTab
- Welcome card với thông tin chào mừng
- Quick actions section với các nút hành động
- Giao diện sạch sẽ và modern

### MyProfileTab
- Profile header với thông tin user
- Menu options (Chỉnh sửa hồ sơ, Đổi mật khẩu, Cài đặt)
- Nút đăng xuất
- Hiển thị trạng thái email verification

### Navigation
- Bottom tab bar với 2 tabs: Home và My Profile
- Top navigation bar với tên trang
- Smooth transitions giữa các tab

## 🎨 Theme

App sử dụng theme đen trắng:
- Background: Đen
- Cards: Trắng
- Text: Đen trên nền trắng, trắng trên nền đen
- Icons: Đen
- Buttons: Đen với text trắng

## 📝 TODO

- [ ] Thêm tính năng chỉnh sửa hồ sơ
- [ ] Thêm tính năng đổi mật khẩu
- [ ] Thêm tính năng cài đặt
- [ ] Thêm loading states
- [ ] Thêm error handling
- [ ] Thêm animations
- [ ] Thêm unit tests
- [ ] Thêm widget tests 