# ⚙️ معمارية الخوادم (Backend Architecture)

## 🚀 Go lang & Gin Framework
اختيار Go lang يعكس حاجة اللعبة لأداء عالٍ (High Concurrency) للتعامل مع آلاف الطلبات في نفس الوقت أثناء الفعاليات (Events).

### 1. طبقات النظام (System Layers)
* **API Gateway / Handlers:** واجهة التعامل مع الطلبات (Gin Routers) والتحقق الأولي.
* **Service Layer:** تحتوي على المنطق البرمجي (Business Logic) مثل حساب النقاط (XP)، الترقية، وفحص بيانات اللعب لمنع الغش (Anti-cheat/Validation).
* **Repository Layer:** التعامل مع قاعدة البيانات (PostgreSQL) للحفظ الدائم، والـ (Memcached/Redis) للبيانات السريعة.

### 2. تدفق البيانات (Data Flow)
* **نهاية الرنة (End of Run):** عندما يموت اللاعب أو ينهي المرحلة، يتم إرسال حمولة (Payload) مشفرة تحتوي على كل الـ Commits (النقاط/الأسلحة) المجمعة.
* **التحقق (Validation):** يقوم الخادم بمراجعة سرعة تجميع النقاط والوقت المستغرق (Duration). إذا كان هناك تلاعب (Cheat detected)، يتم رفض الطلب.
* **التحديث (State Update):** يتم تسجيل النتائج في PostgreSQL، ويتم تحديث الـ Leaderboard المباشر في الـ Cache.

### 3. الاتصال المباشر (Real-time Communication)
* إضافة **WebSockets** لنقل الأحداث المباشرة (Live Events) أو الإشعارات أثناء وجود اللاعب في الـ Hub.

---
⬅️ **العودة إلى لوحة التحكم:** [[00_Dashboard.md.md|لوحة التحكم الرئيسية]]
