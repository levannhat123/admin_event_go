# Admin Event Go

Ứng dụng Flutter quản trị sự kiện, danh mục, đơn hàng và người dùng/staff.

## Công nghệ sử dụng

- Flutter (SDK Dart `^3.8.1`)
- State management: `provider`
- Routing: `go_router`
- DI: `get_it`
- Backend/Storage: `supabase_flutter`, `cloud_firestore`, `firebase_storage`
- UI/Chart: `flutter_screenutil`, `fl_chart`, `flutter_svg`
- Model codegen: `freezed`, `json_serializable`

## Cấu trúc dự án

```text
lib/
  core/            # constants, config, widgets, utils, base classes
  data/            # models, repositories, services
  domain/          # entities, usecases, utils
  presentation/    # pages, widgets, view_models
  routers/         # app routes
  injection/       # dependency injection setup
  main.dart        # app bootstrap
```

## Yêu cầu môi trường

- Flutter stable
- Dart SDK compatible với `^3.8.1`
- Android Studio / Xcode (nếu build mobile)

Kiểm tra nhanh:

```bash
flutter --version
dart --version
```

## Cài đặt và chạy local

1. Cài dependencies:

```bash
flutter pub get
```

2. Tạo file môi trường:

```bash
cp .env.example .env
```

3. Cập nhật giá trị trong `.env`:

```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

4. Chạy app:

```bash
flutter run
```

## Biến môi trường

Project hiện đọc cấu hình Supabase qua `flutter_dotenv` trong `main.dart` và `SupabaseConfig`.

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

Lưu ý:

- `.env` đã được ignore trong git.
- Không commit secrets thật lên repository.

## Lệnh phát triển thường dùng

```bash
# format code
dart format lib

# analyze
flutter analyze

# chạy test
flutter test

# generate code freezed/json
dart run build_runner build --delete-conflicting-outputs
```

## Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (macOS + Xcode)
flutter build ios --release
```

## Gợi ý workflow

- Tách logic theo `domain/usecase` và `presentation/view_models`.
- Tái sử dụng hằng số UI trong `core/constants` (`AppColors`, `AppSizes`, ...).
- Khi thêm model mới có `freezed`, chạy lại `build_runner`.
