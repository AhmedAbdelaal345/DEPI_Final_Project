# Firebase Functions Setup Guide

## إعداد Stripe مع Firebase Functions

### الخطوات المطلوبة:

#### 1. تثبيت Firebase CLI (إذا لم يكن مثبت)
```bash
npm install -g firebase-tools
```

#### 2. تسجيل الدخول إلى Firebase
```bash
firebase login
```

#### 3. تعيين مفتاح Stripe في متغيرات البيئة
```bash
firebase functions:config:set stripe.secret_key="sk_test_51SDRaLPxDRIjAZJWAY6oRfqfoBMDocBHyvcRiEYlr4B2ij7PAXTQShqw49cLRWxrrGLPQ8g5iGp6yKmMgO6nO6DG00R8vXTX8A"
```

#### 4. التحقق من التكوين
```bash
firebase functions:config:get
```

#### 5. تثبيت الحزم المطلوبة
```bash
cd functions
npm install
```

#### 6. نشر الدوال
```bash
firebase deploy --only functions
```

### للتطوير المحلي:

#### 1. تحميل التكوين المحلي
```bash
firebase functions:config:get > .runtimeconfig.json
```

#### 2. تشغيل المحاكي المحلي
```bash
firebase emulators:start --only functions
```

## ملاحظات مهمة:

⚠️ **لا تنشر المفاتيح السرية في الكود المصدري أبداً!**
✅ استخدم دائماً متغيرات البيئة للبيانات الحساسة
🔒 تأكد من إضافة `.runtimeconfig.json` إلى `.gitignore`

## التحسينات المضافة:

1. ✅ نقل مفتاح Stripe إلى متغيرات البيئة
2. ✅ التحقق من صلاحيات المستخدم (Authentication)
3. ✅ التحقق من صحة البيانات المدخلة (Validation)
4. ✅ إضافة metadata للمعاملات (User ID & Timestamp)
5. ✅ معالجة أفضل للأخطاء (Better Error Handling)
6. ✅ تأكيد أن المبلغ عدد صحيح (Round amount)

