[//]: # (# Profile Feature)

[//]: # ()
[//]: # (## 📁 Structure Overview)

[//]: # ()
[//]: # (```)

[//]: # (lib/features/profile/)

[//]: # (├── presentation/)

[//]: # (│   ├── screens/)

[//]: # (│   │   ├── profile_screen.dart           # الصفحة الرئيسية للملف الشخصي)

[//]: # (│   │   ├── pro_features_screen.dart      # شاشة عرض مميزات Pro)

[//]: # (│   │   └── payment_screen.dart           # شاشة الدفع والاشتراك)

[//]: # (│   ├── widgets/)

[//]: # (│   │   ├── profile_header.dart           # رأس الصفحة مع الأنيميشن)

[//]: # (│   │   ├── pro_upgrade_card.dart         # بطاقة الترقية لـ Pro)

[//]: # (│   │   ├── stat_card.dart                # بطاقة الإحصائيات)

[//]: # (│   │   ├── payment_card_preview.dart     # معاينة البطاقة الائتمانية)

[//]: # (│   │   └── payment_text_field.dart       # حقل إدخال الدفع)

[//]: # (│   └── utils/)

[//]: # (│       └── card_formatters.dart          # منسقات رقم البطاقة والتاريخ)

[//]: # (├── data/)

[//]: # (│   ├── models/                           # نماذج البيانات &#40;للتطوير المستقبلي&#41;)

[//]: # (│   └── repositories/                     # Repositories &#40;للتطوير المستقبلي&#41;)

[//]: # (└── domain/)

[//]: # (    ├── entities/                         # Entities &#40;للتطوير المستقبلي&#41;)

[//]: # (    └── repositories/                     # Repository interfaces)

[//]: # (```)

[//]: # ()
[//]: # (## 🎯 Features)

[//]: # ()
[//]: # (### 1. Profile Screen)

[//]: # (- **عرض معلومات المستخدم**: الاسم، البريد الإلكتروني، الصورة الشخصية)

[//]: # (- **أنيميشن Pro**: حلقة دوران متوهجة حول صورة المستخدمين المشتركين)

[//]: # (- **شارة PRO**: badge متحرك بجانب اسم المستخدم)

[//]: # (- **إحصائيات**: عدد الكويزات، المواد، متوسط الدرجات)

[//]: # (- **بطاقة الترقية**: تظهر فقط للمستخدمين غير المشتركين)

[//]: # ()
[//]: # (### 2. Pro Features Screen)

[//]: # (- **شارة Premium**: تصميم جذاب مع gradient)

[//]: # (- **بطاقة السعر**: عرض السعر الشهري &#40;$9.99&#41;)

[//]: # (- **قائمة المميزات**: 6 مميزات للنسخة Pro:)

[//]: # (  - ✅ Unlimited Quizzes)

[//]: # (  - 📊 Advanced Analytics)

[//]: # (  - 🏆 Priority Support)

[//]: # (  - 📴 Offline Mode)

[//]: # (  - 💾 Export Results)

[//]: # (  - 🔄 Cloud Sync)

[//]: # ()
[//]: # (### 3. Payment Screen)

[//]: # (- **معاينة البطاقة التفاعلية**: تتحدث فوريًا مع البيانات المدخلة)

[//]: # (- **حقول الإدخال**:)

[//]: # (  - رقم البطاقة &#40;تنسيق تلقائي: `1234 5678 9012 3456`&#41;)

[//]: # (  - اسم صاحب البطاقة)

[//]: # (  - تاريخ الانتهاء &#40;تنسيق تلقائي: `MM/YY`&#41;)

[//]: # (  - CVV &#40;مخفي&#41;)

[//]: # (- **ملخص الدفع**: عرض تفاصيل الاشتراك)

[//]: # (- **Validation**: التحقق من صحة البيانات)

[//]: # (- **Success Dialog**: رسالة نجاح بعد الدفع)

[//]: # ()
[//]: # (## 🎨 Animations)

[//]: # ()
[//]: # (### Profile Header Animation)

[//]: # (- **Rotating Gradient Border**: حلقة دائرية تدور باستمرار)

[//]: # (- **Colors**: Teal → Light Teal → Gold → Teal)

[//]: # (- **Duration**: 3 seconds per rotation)

[//]: # (- **Smooth Transition**: باستخدام `AnimationController` و `SweepGradient`)

[//]: # ()
[//]: # (## 🔧 Components)

[//]: # ()
[//]: # (### Reusable Widgets)

[//]: # ()
[//]: # (#### ProfileHeader)

[//]: # (```dart)

[//]: # (ProfileHeader&#40;)

[//]: # (  userName: "User Name",)

[//]: # (  userEmail: "email@example.com",)

[//]: # (  profileImageUrl: "assets/image.png",)

[//]: # (  isPro: true,)

[//]: # (&#41;)

[//]: # (```)

[//]: # ()
[//]: # (#### ProUpgradeCard)

[//]: # (```dart)

[//]: # (ProUpgradeCard&#40;)

[//]: # (  onTap: &#40;&#41; {)

[//]: # (    // Navigate to ProFeaturesScreen)

[//]: # (  },)

[//]: # (&#41;)

[//]: # (```)

[//]: # ()
[//]: # (#### StatCard)

[//]: # (```dart)

[//]: # (StatCard&#40;)

[//]: # (  icon: IconParkOutline.list,)

[//]: # (  label: "All Quizzes taken",)

[//]: # (  value: "9",)

[//]: # (&#41;)

[//]: # (```)

[//]: # ()
[//]: # (#### PaymentCardPreview)

[//]: # (```dart)

[//]: # (PaymentCardPreview&#40;)

[//]: # (  cardNumber: cardNumberController.text,)

[//]: # (  cardHolder: cardHolderController.text,)

[//]: # (  expiryDate: expiryDateController.text,)

[//]: # (&#41;)

[//]: # (```)

[//]: # ()
[//]: # (#### PaymentTextField)

[//]: # (```dart)

[//]: # (PaymentTextField&#40;)

[//]: # (  controller: controller,)

[//]: # (  label: "Card Number",)

[//]: # (  hint: "1234 5678 9012 3456",)

[//]: # (  icon: Icons.credit_card,)

[//]: # (  keyboardType: TextInputType.number,)

[//]: # (  maxLength: 19,)

[//]: # (  inputFormatters: [CardNumberFormatter&#40;&#41;],)

[//]: # (&#41;)

[//]: # (```)

[//]: # ()
[//]: # (## 🛠️ Utilities)

[//]: # ()
[//]: # (### Card Formatters)

[//]: # ()
[//]: # (#### CardNumberFormatter)

[//]: # (- تنسيق رقم البطاقة تلقائيًا: `1234567890123456` → `1234 5678 9012 3456`)

[//]: # ()
[//]: # (#### ExpiryDateFormatter)

[//]: # (- تنسيق تاريخ الانتهاء: `1225` → `12/25`)

[//]: # ()
[//]: # (## 🔄 User Flow)

[//]: # ()
[//]: # (```)

[//]: # (Profile Screen &#40;isPro = false&#41;)

[//]: # (    ↓)

[//]: # (    Click "View Benefits")

[//]: # (    ↓)

[//]: # (Pro Features Screen)

[//]: # (    ↓)

[//]: # (    Click "Subscribe Now")

[//]: # (    ↓)

[//]: # (Payment Screen)

[//]: # (    ↓)

[//]: # (    Enter card details)

[//]: # (    ↓)

[//]: # (    Click "Pay $9.99")

[//]: # (    ↓)

[//]: # (Success Dialog)

[//]: # (    ↓)

[//]: # (    Click "Get Started")

[//]: # (    ↓)

[//]: # (Navigate to Home &#40;with isPro = true&#41;)

[//]: # (```)

[//]: # ()
[//]: # (## 📦 Dependencies)

[//]: # ()
[//]: # (```yaml)

[//]: # (dependencies:)

[//]: # (  flutter:)

[//]: # (    sdk: flutter)

[//]: # (  iconify_flutter: ^latest  # للأيقونات)

[//]: # (```)

[//]: # ()
[//]: # (## 🎯 Usage)

[//]: # ()
[//]: # (### Import Profile Screen)

[//]: # (```dart)

[//]: # (import 'package:your_app/features/profile/presentation/screens/profile_screen.dart';)

[//]: # ()
[//]: # (// In your navigation)

[//]: # (Navigator.push&#40;)

[//]: # (  context,)

[//]: # (  MaterialPageRoute&#40;)

[//]: # (    builder: &#40;_&#41; => ProfileScreen&#40;)

[//]: # (      userName: "User Name",)

[//]: # (      userEmail: "user@example.com",)

[//]: # (      isPro: false, // or true for Pro users)

[//]: # (      quizzesTaken: 10,)

[//]: # (      subjects: 5,)

[//]: # (      averageScore: 85,)

[//]: # (    &#41;,)

[//]: # (  &#41;,)

[//]: # (&#41;;)

[//]: # (```)

[//]: # ()
[//]: # (### Check Pro Status)

[//]: # (```dart)

[//]: # (// In ProfileScreen)

[//]: # (final bool isPro = false; // Get from Firebase/Backend)

[//]: # ()
[//]: # (// Shows different UI based on status:)

[//]: # (if &#40;!isPro&#41; {)

[//]: # (  // Show ProUpgradeCard)

[//]: # (} else {)

[//]: # (  // Show Pro badge with animation)

[//]: # (})

[//]: # (```)

[//]: # ()
[//]: # (## 🚀 Next Steps for Development)

[//]: # ()
[//]: # (### 1. State Management)

[//]: # (- [ ] إضافة Cubit/Bloc لإدارة حالة الاشتراك)

[//]: # (- [ ] إدارة حالة الدفع &#40;loading, success, error&#41;)

[//]: # (- [ ] Cache حالة الاشتراك محليًا)

[//]: # ()
[//]: # (### 2. Backend Integration)

[//]: # (- [ ] ربط مع Stripe/PayPal API)

[//]: # (- [ ] إنشاء endpoint للاشتراك)

[//]: # (- [ ] التحقق من صحة الدفع)

[//]: # (- [ ] حفظ حالة الاشتراك في Firestore)

[//]: # ()
[//]: # (### 3. Data Layer)

[//]: # (```dart)

[//]: # (// models/subscription_model.dart)

[//]: # (class SubscriptionModel {)

[//]: # (  final String userId;)

[//]: # (  final bool isPro;)

[//]: # (  final DateTime? subscriptionDate;)

[//]: # (  final DateTime? expiryDate;)

[//]: # (  final String? subscriptionId;)

[//]: # (})

[//]: # ()
[//]: # (// repositories/subscription_repository.dart)

[//]: # (abstract class SubscriptionRepository {)

[//]: # (  Future<bool> checkProStatus&#40;String userId&#41;;)

[//]: # (  Future<void> subscribeUser&#40;String userId, PaymentInfo payment&#41;;)

[//]: # (  Future<void> cancelSubscription&#40;String userId&#41;;)

[//]: # (})

[//]: # (```)

[//]: # ()
[//]: # (### 4. Domain Layer)

[//]: # (```dart)

[//]: # (// entities/user_profile.dart)

[//]: # (class UserProfile {)

[//]: # (  final String id;)

[//]: # (  final String name;)

[//]: # (  final String email;)

[//]: # (  final bool isPro;)

[//]: # (  final ProfileStats stats;)

[//]: # (})

[//]: # ()
[//]: # (// use_cases/subscribe_to_pro.dart)

[//]: # (class SubscribeToProUseCase {)

[//]: # (  Future<Either<Failure, Success>> call&#40;PaymentInfo payment&#41;;)

[//]: # (})

[//]: # (```)

[//]: # ()
[//]: # (### 5. Testing)

[//]: # (- [ ] Unit tests لـ formatters)

[//]: # (- [ ] Widget tests للـ components)

[//]: # (- [ ] Integration tests للـ payment flow)

[//]: # ()
[//]: # (### 6. Additional Features)

[//]: # (- [ ] إضافة خطط اشتراك متعددة &#40;شهري، سنوي&#41;)

[//]: # (- [ ] Discount codes)

[//]: # (- [ ] Trial period &#40;7 أيام مجانًا&#41;)

[//]: # (- [ ] إدارة الاشتراك &#40;إلغاء، تجديد&#41;)

[//]: # (- [ ] Invoice history)

[//]: # ()
[//]: # (## 🎨 Design System)

[//]: # ()
[//]: # (### Colors)

[//]: # (- **Background Dark**: `#000920`)

[//]: # (- **Background Light**: `#1A1C2B`)

[//]: # (- **Primary Teal**: `#4FB3B7`)

[//]: # (- **Light Teal**: `#5AC7C7`)

[//]: # (- **Highlight Teal**: `#84D9D7`)

[//]: # (- **Gold**: `#FFD700`)

[//]: # ()
[//]: # (### Typography)

[//]: # (- **Title**: 20px, Bold)

[//]: # (- **Subtitle**: 16px, Medium)

[//]: # (- **Body**: 14px, Regular)

[//]: # (- **Caption**: 12px, Regular)

[//]: # ()
[//]: # (### Spacing)

[//]: # (- **Small**: 8px)

[//]: # (- **Medium**: 16px)

[//]: # (- **Large**: 24px)

[//]: # (- **XLarge**: 32px)

[//]: # ()
[//]: # (## 📝 Notes)

[//]: # ()
[//]: # (- ⚠️ **Security**: لا تحفظ بيانات البطاقة على الجهاز)

[//]: # (- 🔒 **Encryption**: استخدم HTTPS لجميع API calls)

[//]: # (- 💳 **PCI Compliance**: استخدم Stripe/PayPal لمعالجة الدفع)

[//]: # (- 📱 **Testing**: اختبر على أجهزة مختلفة)

[//]: # (- 🌐 **Localization**: جاهز لدعم لغات متعددة)

[//]: # ()
[//]: # (## 🐛 Known Issues)

[//]: # ()
[//]: # (- [ ] يحتاج إلى ربط مع backend حقيقي)

[//]: # (- [ ] حالة الاشتراك static حاليًا &#40;isPro&#41;)

[//]: # (- [ ] لا يوجد error handling للدفع الفاشل)

[//]: # (- [ ] يحتاج إلى loading states)

[//]: # ()
[//]: # (## 📞 Support)

[//]: # ()
[//]: # (للمساعدة في تطوير feature الـ Profile، يمكن الرجوع إلى:)

[//]: # (- [Stripe Documentation]&#40;https://stripe.com/docs&#41;)

[//]: # (- [Flutter Payment Guide]&#40;https://flutter.dev/docs/cookbook/plugins/payment&#41;)

[//]: # (- [Clean Architecture in Flutter]&#40;https://resocoder.com/flutter-clean-architecture-tdd/&#41;)

[//]: # ()
[//]: # (---)

[//]: # ()
[//]: # (**Last Updated**: October 2025)

[//]: # (**Version**: 1.0.0)

[//]: # (**Status**: ✅ UI Complete | ⏳ Backend Integration Pending)

[//]: # ()
