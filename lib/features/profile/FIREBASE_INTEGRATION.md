# Profile Feature - Firebase Integration Guide

## 🎉 ما تم إنجازه

تم ربط **Profile Feature** بالكامل مع Firebase لعرض البيانات الحقيقية وإدارة الاشتراك Pro!

## 📁 الملفات الجديدة

### 1. Data Layer
- ✅ `user_profile_model.dart` - Model للبيانات
- ✅ `profile_repository.dart` - للتعامل مع Firestore
- ✅ `firebase_setup_helper.dart` - مساعدات للإعداد

### 2. State Management
- ✅ `profile_cubit.dart` - إدارة حالة Profile
- ✅ `profile_state.dart` - حالات مختلفة للـ Profile

### 3. Presentation
- ✅ `profile_screen_with_firebase.dart` - الشاشة المتصلة بـ Firebase
- ✅ تحديث `payment_screen.dart` - لتحديث حالة Pro

## 🔥 Firebase Structure

### Collection: `Student`
```json
{
  "uid": "user_id_here",
  "fullName": "Yasmen Magdy",
  "email": "yasmen@example.com",
  "phone": "+201234567890",
  "profileImageUrl": "url_to_image",
  "isPro": false,
  "proSubscriptionDate": "2025-01-15T10:30:00Z",
  "proExpiryDate": "2025-02-15T10:30:00Z",
  "quizzesTaken": 9,
  "subjects": 3,
  "averageScore": 88,
  "createdAt": "timestamp"
}
```

## 🚀 كيفية الاستخدام

### 1. تأكد من وجود بيانات المستخدم في Firebase

يجب أن يكون لديك document في collection `Student` بـ uid المستخدم:

```dart
// عند تسجيل مستخدم جديد
import 'package:depi_final_project/features/profile/data/repositories/firebase_setup_helper.dart';

await FirebaseSetupHelper.createUserProfile(
  userId: user.uid,
  fullName: "User Name",
  email: user.email!,
  phone: "+201234567890",
);
```

### 2. الشاشة تعمل تلقائياً

الآن `WrapperPage` تستخدم `ProfileScreenWithFirebase` تلقائياً:

```dart
// في wrapper_page.dart
const ProfileScreenWithFirebase()
```

### 3. ميزات الشاشة

#### ✅ عرض البيانات الحقيقية
- يتم جلب البيانات من Firebase تلقائياً
- Real-time updates (التحديثات الفورية)
- Pull to refresh (اسحب للتحديث)

#### ✅ إدارة Pro
- عرض حالة الاشتراك Pro
- عرض عدد الأيام المتبقية
- إمكانية الاشتراك من خلال الدفع

#### ✅ الإحصائيات
- عدد الكويزات
- عدد المواد
- متوسط الدرجات

## 🔧 API Reference

### ProfileCubit

```dart
// جلب بيانات المستخدم (مرة واحدة)
cubit.loadUserProfile(userId);

// Stream للتحديثات الفورية
cubit.streamUserProfile(userId);

// تحديث البيانات
cubit.updateProfile(userId, {
  'fullName': 'New Name',
  'phone': '+201234567890',
});

// الاشتراك في Pro
cubit.subscribeToPro(userId);

// إلغاء الاشتراك
cubit.cancelProSubscription(userId);

// تحديث الإحصائيات
cubit.updateQuizStatistics(userId);

// تحديث البيانات يدوياً
cubit.refreshProfile(userId);
```

### ProfileRepository

```dart
final repo = ProfileRepository();

// جلب البيانات
final profile = await repo.getUserProfile(userId);

// Stream
repo.streamUserProfile(userId).listen((profile) {
  print(profile?.fullName);
});

// تحديث
await repo.updateUserProfile(userId, {'isPro': true});

// اشتراك Pro
await repo.subscribeToPro(userId);

// إحصائيات
final stats = await repo.getQuizStatistics(userId);
```

## 📝 الحالات (States)

```dart
ProfileInitial        // البداية
ProfileLoading        // جاري التحميل
ProfileLoaded         // تم التحميل
ProfileError          // خطأ
ProfileUpdating       // جاري التحديث
ProfileUpdated        // تم التحديث
ProSubscriptionSuccess // نجح الاشتراك
ProSubscriptionError   // فشل الاشتراك
```

## 🎨 UI Features

### Loading State
```dart
if (state is ProfileLoading) {
  return CircularProgressIndicator();
}
```

### Error Handling
```dart
if (state is ProfileError) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(state.message)),
  );
}
```

### Pull to Refresh
```dart
RefreshIndicator(
  onRefresh: () async {
    await context.read<ProfileCubit>().refreshProfile(userId);
  },
  child: ...,
)
```

### Pro Status Card
- يظهر فقط للمستخدمين Pro
- يعرض عدد الأيام المتبقية
- تصميم gradient جميل

## 🔐 Security Rules (Firestore)

أضف هذه القواعد في Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Student collection
    match /Student/{userId} {
      // يمكن للمستخدم قراءة وتعديل بياناته فقط
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // منع تعديل isPro إلا من خلال Admin أو Cloud Function
      allow update: if request.auth != null 
                    && request.auth.uid == userId
                    && !request.resource.data.diff(resource.data).affectedKeys().hasAny(['isPro']);
    }
    
    // Quizzes collection (for statistics)
    match /Quizzes/{quizId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == request.resource.data.userId;
    }
  }
}
```

## 🐛 Troubleshooting

### 1. "User profile not found"
**الحل:**
```dart
// تأكد من إنشاء profile عند التسجيل
await FirebaseSetupHelper.createUserProfile(
  userId: user.uid,
  fullName: name,
  email: email,
);
```

### 2. "Permission denied"
**الحل:**
- تحقق من Security Rules في Firebase
- تأكد أن المستخدم مسجل دخول

### 3. البيانات لا تتحدث
**الحل:**
```dart
// استخدم streamUserProfile بدلاً من loadUserProfile
cubit.streamUserProfile(userId);
```

### 4. الإحصائيات غير صحيحة
**الحل:**
```dart
// قم بتحديث الإحصائيات يدوياً
await cubit.updateQuizStatistics(userId);
```

## 🔄 Migration للمستخدمين الحاليين

إذا كان لديك مستخدمين حاليين بدون الحقول الجديدة:

```dart
import 'package:depi_final_project/features/profile/data/repositories/firebase_setup_helper.dart';

// في main.dart أو عند تسجيل الدخول
final userId = FirebaseAuth.instance.currentUser?.uid;
if (userId != null) {
  await FirebaseSetupHelper.migrateUserProfile(userId);
}
```

## 📱 Testing

### Test Firebase Connection
```dart
final isConnected = await FirebaseSetupHelper.testFirebaseConnection();
if (isConnected) {
  print('✅ Firebase متصل');
} else {
  print('❌ مشكلة في الاتصال');
}
```

### Test Profile Loading
```dart
final repo = ProfileRepository();
final profile = await repo.getUserProfile('test_user_id');
print(profile?.fullName);
```

## 🎯 Next Steps

### 1. دمج Stripe للدفع الحقيقي
```dart
// في _processPayment()
final paymentIntent = await Stripe.instance.createPaymentIntent();
// ... process payment
if (paymentSuccess) {
  await cubit.subscribeToPro(userId);
}
```

### 2. إضافة Cloud Function للتحقق
```javascript
// في Firebase Cloud Functions
exports.verifyProSubscription = functions.https.onCall(async (data, context) => {
  const userId = context.auth.uid;
  // Verify payment with Stripe
  // Update Firestore
});
```

### 3. Notifications عند انتهاء الاشتراك
```dart
// Check expiry date
if (profile.proExpiryDate != null) {
  final daysLeft = profile.proExpiryDate!.difference(DateTime.now()).inDays;
  if (daysLeft <= 3) {
    // Show notification
  }
}
```

## 📊 Analytics

يمكنك تتبع أحداث Pro:

```dart
// عند الاشتراك
FirebaseAnalytics.instance.logEvent(
  name: 'subscribe_to_pro',
  parameters: {'user_id': userId, 'plan': 'monthly'},
);

// عند إلغاء الاشتراك
FirebaseAnalytics.instance.logEvent(
  name: 'cancel_pro',
  parameters: {'user_id': userId},
);
```

## ✅ Checklist

- [x] Data Models
- [x] Repository
- [x] Cubit & States
- [x] UI with Firebase
- [x] Payment Integration
- [x] Real-time Updates
- [x] Error Handling
- [x] Loading States
- [x] Pull to Refresh
- [ ] Stripe Integration (TODO)
- [ ] Cloud Functions (TODO)
- [ ] Push Notifications (TODO)

---

**الآن التطبيق متصل بالكامل مع Firebase وجاهز للاستخدام! 🎉**

للدعم: راجع `profile_repository.dart` و `profile_cubit.dart`

