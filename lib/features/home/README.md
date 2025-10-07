[//]: # (# Home Feature)

[//]: # ()
[//]: # (## Structure Overview)

[//]: # ()
[//]: # (```)

[//]: # (lib/features/home/)

[//]: # (├── presentation/)

[//]: # (│   ├── Screens/)

[//]: # (│   │   ├── home_screen.dart              # الصفحة الرئيسية لإدخال كود الكويز)

[//]: # (│   │   ├── profile_screen.dart           # صفحة الملف الشخصي)

[//]: # (│   │   ├── quiz_history_screen.dart      # صفحة تاريخ الكويزات)

[//]: # (│   │   ├── quiz_list_screen.dart         # قائمة الكويزات لكل مادة)

[//]: # (│   │   ├── quiz_details_screen.dart      # تفاصيل الكويز)

[//]: # (│   │   ├── setting_screen.dart           # صفحة الإعدادات)

[//]: # (│   │   ├── teacher_screen.dart           # صفحة المعلم)

[//]: # (│   │   └── wrapper_page.dart             # Wrapper للـ Navigation Bar)

[//]: # (│   └── widgets/)

[//]: # (│       ├── app_constants.dart            # الثوابت والألوان &#40;Legacy&#41;)

[//]: # (│       ├── app_drawer.dart               # القائمة الجانبية)

[//]: # (│       ├── custom_app_bar.dart           # شريط التطبيق المخصص ✨ NEW)

[//]: # (│       ├── custom_button.dart            # زر مخصص ✨ NEW)

[//]: # (│       ├── curved_bottom_nav.dart        # شريط التنقل السفلي)

[//]: # (│       ├── detail_item.dart              # عنصر تفاصيل الكويز)

[//]: # (│       ├── info_card.dart                # بطاقة معلومات)

[//]: # (│       ├── input_field.dart              # حقل إدخال)

[//]: # (│       ├── instructions_card.dart        # بطاقة التعليمات)

[//]: # (│       ├── journey_start_button.dart     # زر بدء الرحلة)

[//]: # (│       ├── primary_button.dart           # الزر الأساسي)

[//]: # (│       ├── quiz_card.dart                # بطاقة الكويز)

[//]: # (│       ├── settings_tile.dart            # عنصر الإعدادات ✨ NEW)

[//]: # (│       ├── stat_card.dart                # بطاقة الإحصائيات ✨ NEW)

[//]: # (│       └── title_bar.dart                # شريط العنوان)

[//]: # (├── data/                                 # &#40;Empty - للتطوير المستقبلي&#41;)

[//]: # (├── domain/                               # &#40;Empty - للتطوير المستقبلي&#41;)

[//]: # (└── cubit/                                # &#40;Empty - للتطوير المستقبلي&#41;)

[//]: # (```)

[//]: # ()
[//]: # (## Recent Improvements ✨)

[//]: # ()
[//]: # (### 1. **Created Reusable Widgets**)

[//]: # (   - `CustomAppBar`: شريط تطبيق موحد لجميع الشاشات)

[//]: # (   - `CustomButton`: زر قابل لإعادة الاستخدام مع تخصيص الألوان)

[//]: # (   - `SettingsTile`: عنصر موحد لقائمة الإعدادات)

[//]: # (   - `StatCard`: بطاقة الإحصائيات في صفحة الملف الشخصي)

[//]: # ()
[//]: # (### 2. **Code Organization**)

[//]: # (   - فصل الـ logic عن الـ UI في جميع الشاشات)

[//]: # (   - استخدام دوال helper منفصلة &#40;`_build*` methods&#41;)

[//]: # (   - تحسين قابلية القراءة والصيانة)

[//]: # ()
[//]: # (### 3. **Consistent Styling**)

[//]: # (   - استخدام `AppTheme` للألوان والثوابت)

[//]: # (   - توحيد الـ padding والـ spacing)

[//]: # (   - توحيد الـ border radius والألوان)

[//]: # ()
[//]: # (### 4. **Better Navigation**)

[//]: # (   - فصل logic الـ navigation في دوال منفصلة)

[//]: # (   - تحسين تمرير الـ parameters)

[//]: # ()
[//]: # (## Screens Description)

[//]: # ()
[//]: # (### Home Screen)

[//]: # (- صفحة إدخال كود الكويز)

[//]: # (- يحتوي على حقل إدخال وزر للانضمام)

[//]: # ()
[//]: # (### Profile Screen)

[//]: # (- عرض معلومات المستخدم)

[//]: # (- إحصائيات الكويزات &#40;عدد الكويزات، المواد، المتوسط&#41;)

[//]: # ()
[//]: # (### Quiz History Screen)

[//]: # (- عرض جميع المواد مع متوسط الدرجات)

[//]: # (- الانتقال لقائمة الكويزات عند الضغط على مادة)

[//]: # ()
[//]: # (### Quiz List Screen)

[//]: # (- عرض جميع الكويزات لمادة معينة)

[//]: # (- الانتقال لتفاصيل الكويز عند الضغط)

[//]: # ()
[//]: # (### Quiz Details Screen)

[//]: # (- عرض تفاصيل الكويز &#40;عدد الأسئلة، الوقت، المنشئ، إلخ&#41;)

[//]: # (- أزرار لإعادة حل الكويز أو عرض الإجابات)

[//]: # ()
[//]: # (### Settings Screen)

[//]: # (- إعدادات التطبيق &#40;الإشعارات، الثيم، اللغة، إلخ&#41;)

[//]: # ()
[//]: # (## Widgets Description)

[//]: # ()
[//]: # (### CustomAppBar)

[//]: # (```dart)

[//]: # (CustomAppBar&#40;)

[//]: # (  title: "Screen Title",)

[//]: # (  showBackButton: true,)

[//]: # (  onBackPressed: &#40;&#41; {},)

[//]: # (&#41;)

[//]: # (```)

[//]: # ()
[//]: # (### CustomButton)

[//]: # (```dart)

[//]: # (CustomButton&#40;)

[//]: # (  label: "Button Text",)

[//]: # (  onPressed: &#40;&#41; {},)

[//]: # (  backgroundColor: Colors.blue,)

[//]: # (  textColor: Colors.white,)

[//]: # (&#41;)

[//]: # (```)

[//]: # ()
[//]: # (### StatCard)

[//]: # (```dart)

[//]: # (StatCard&#40;)

[//]: # (  icon: IconParkOutline.list,)

[//]: # (  label: "Quizzes",)

[//]: # (  value: "9",)

[//]: # (&#41;)

[//]: # (```)

[//]: # ()
[//]: # (### QuizCard)

[//]: # (```dart)

[//]: # (QuizCard&#40;)

[//]: # (  title: "Math Basics",)

[//]: # (  subtitle: "Completed on 23/9/2025",)

[//]: # (  score: "80%",)

[//]: # (  showAverage: false,)

[//]: # (&#41;)

[//]: # (```)

[//]: # ()
[//]: # (## Next Steps for Development 🚀)

[//]: # ()
[//]: # (1. **State Management**: إضافة Cubit/Bloc للـ state management)

[//]: # (2. **Data Layer**: إنشاء repositories و data sources)

[//]: # (3. **Domain Layer**: إنشاء entities و use cases)

[//]: # (4. **API Integration**: ربط الـ screens مع الـ backend)

[//]: # (5. **Error Handling**: إضافة error handling شامل)

[//]: # (6. **Testing**: كتابة unit tests و widget tests)

[//]: # ()
[//]: # (## Color Scheme)

[//]: # ()
[//]: # (- Background Dark: `#000921`)

[//]: # (- Background Light: `#1A1C2B`)

[//]: # (- Primary Teal: `#4FB3B7`)

[//]: # (- Primary Teal Light: `#5AC7C7`)

[//]: # (- Text White: `#FFFFFF`)

[//]: # (- Text Grey: `#B0B0B0`)

[//]: # ()
[//]: # (## Dependencies)

[//]: # ()
[//]: # (- `flutter/material.dart`)

[//]: # (- `iconify_flutter` - for icons)

[//]: # (- `curved_navigation_bar` - for bottom navigation)

[//]: # ()
[//]: # (---)

[//]: # ()
[//]: # (**Note**: هذا الـ feature تم تنظيمه وتحسينه لكن لا يزال يحتاج إلى state management وربط مع backend.)

[//]: # ()
