# دليل الاستخدام السريع - خدمة تحليل البشرة

## الخطوات الأساسية لاستخدام الخدمة في التطبيق:

### 1. إضافة الاستيراد المطلوب
```dart
import '../../../../core/Services/API/skin_care_api_service.dart';
import 'package:url_launcher/url_launcher.dart';
```

### 2. إنشاء مثيل من الخدمة
```dart
final SkinCareApiService _skinCareApiService = SkinCareApiService();
```

### 3. التحقق من حالة الخادم
```dart
@override
void initState() {
  super.initState();
  _checkServerStatus();
}

Future<void> _checkServerStatus() async {
  try {
    final isConnected = await _skinCareApiService.checkServerStatus();
    setState(() {
      serverConnected = isConnected;
    });
  } catch (e) {
    setState(() {
      serverConnected = false;
    });
  }
}
```

### 4. تحليل البشرة والحصول على التوصيات
```dart
Future<void> _analyzeSkin(XFile imageFile) async {
  setState(() {
    isLoading = true;
  });

  try {
    final result = await _skinCareApiService.analyzeAndRecommend(imageFile: imageFile);
    
    if (result.isSuccessful) {
      // عرض النتائج
      _showResults(result);
    } else {
      // عرض رسالة خطأ
      _showError(result.errorMessage ?? 'فشل في التحليل');
    }
  } catch (e) {
    _showError('خطأ في الاتصال: $e');
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}
```

### 5. عرض النتائج
```dart
void _showResults(CompleteAnalysisResult result) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('نتائج التحليل'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('نوع البشرة: ${result.skinType}'),
          Text('الاهتمام: ${result.concern}'),
          Text('عدد التوصيات: ${result.recommendations.length}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('موافق'),
        ),
      ],
    ),
  );
}
```

## الميزات المتاحة:

### ✅ التحليل الكامل
- تحديد نوع البشرة (دهنية، جافة، عادية)
- تحديد الاهتمامات (حب الشباب، الهالات، المسام، الاحمرار)
- الحصول على التوصيات مباشرة

### ✅ التوصيات الذكية
- منتجات مناسبة لنوع البشرة
- منتجات لعلاج الاهتمامات المحددة
- روابط مباشرة للمنتجات
- أسعار المنتجات

### ✅ معالجة الأخطاء
- فحص حالة الخادم
- رسائل خطأ واضحة
- إعادة المحاولة

### ✅ واجهة مستخدم محسنة
- مؤشر حالة الخادم
- مؤشر التحميل
- خيارات متعددة للصور (كاميرا/معرض)
- عرض النتائج في dialog

## مثال كامل في صفحة الرئيسية:

تم تحديث `home.screen.dart` ليشمل:

1. **مؤشر حالة الخادم** - يظهر إذا كان Flask API يعمل
2. **خيارات التقاط الصورة** - كاميرا أو معرض أو الطريقة القديمة
3. **تحليل مباشر** - بدون الحاجة لصفحة منفصلة
4. **عرض النتائج** - في dialog مع التوصيات
5. **فتح روابط المنتجات** - مباشرة في المتصفح

## كيفية الاختبار:

1. **تشغيل Flask API** على المنفذ 5000
2. **تشغيل التطبيق** وفحص حالة الخادم
3. **التقاط صورة** من الكاميرا أو المعرض
4. **مراقبة النتائج** في dialog
5. **فتح روابط المنتجات** للتأكد من عملها

## نصائح مهمة:

- ✅ تأكد من تشغيل Flask API قبل استخدام التطبيق
- ✅ استخدم صور واضحة للوجه للحصول على أفضل النتائج
- ✅ تحقق من حالة الخادم قبل كل عملية تحليل
- ✅ استخدم مؤشر التحميل لتحسين تجربة المستخدم

---

**الآن يمكنك استخدام الخدمة الجديدة في أي مكان في التطبيق!** 🚀
