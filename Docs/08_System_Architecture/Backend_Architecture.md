# ⚙️ معمارية الخوادم (Backend Architecture)

## 🚀 Go lang & Gin Framework
اختيار Go lang يعكس حاجة اللعبة لأداء عالٍ (High Concurrency) للتعامل مع آلاف الطلبات في نفس الوقت أثناء الفعاليات (Events).

1. **مسارات الـ API (Endpoints):**
   * `POST /api/v1/run/sync`: إرسال الـ Commits والإحصائيات التحليلية (الـ Profiler data) بعد انتهاء كل الرنة.
   * `GET /api/v1/leaderboard`: جلب ترتيب اللاعبين بسرعة فائقة من الـ Cache.
   * `POST /api/v1/meta/upgrade`: تسجيل ترقيات اللاعب (Micro-optimization) في الـ Hub.

2. **الأمان (Security):**
   * تشفير الحمولات (Payloads) بين الموبايل والسيرفر باستخدام JWT وربما Hash للتأكد من عدم تعديل الـ Score في الذاكرة (Memory injection).


---
⬅️ **العودة إلى لوحة التحكم:** [[00_Dashboard.md.md|لوحة التحكم الرئيسية]]
