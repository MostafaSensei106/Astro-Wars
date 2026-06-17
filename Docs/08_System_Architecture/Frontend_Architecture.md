# 📱 معمارية واجهة المستخدم (Frontend Architecture)

## 🏗️ Clean Architecture + BLoC + Flame
تصميم الكود في الجبهة الأمامية سيتبع مبادئ الـ Clean Architecture لضمان استدامة المشروع وسهولة التوسع:

### 1. Presentation Layer
* **Flutter UI:** القوائم الرئيسية، شاشة التطوير (The Hub)، وشاشات الـ Profiler والـ Leaderboard.
* **Game Widget (Flame):** واجهة المحرك. سيتم تمرير الـ `GameBloc` إلى داخله ليكون همزة الوصل بين عالم الـ UI وعالم الـ Game Physics.

### 2. Domain Layer
* يحتوي على الـ Models الخاصة باللاعب، والأسلحة، والأعداء.
* الـ Use Cases (مثل `SyncRunDataUseCase` أو `BuyUpgradeUseCase`).

### 3. Data Layer
* **Repositories:** التعامل مع حفظ الـ Commits محلياً وإرسال طلبات الـ HTTP للباك إند.
* **Data Sources:** التواصل مع الـ REST APIs أو قاعدة البيانات المحلية (Local DB/Hive).

## 🛠️ Flame Architecture (The Implementation Note)
كما ذكرنا في ميكانيكا اللعب، المحرك سيبتعد عن الـ Spaghetti Code عبر نمط المراقبة (Observer Pattern):
* `BasePackageComponent`: صنف مجرد (Abstract) يمثل الـ Power-ups.
* عند حدوث `CollisionCallbacks` بين الـ Player والـ Package، لا يتم تغيير الواجهة مباشرة من المحرك.
* يرسل المحرك حدثاً `PackageCollectedEvent` إلى الـ `GameBloc`.
* يقوم الـ BLoC بتحديث الـ State، فتستجيب واجهة Flutter (HUD) وتعرض السلاح الجديد، ويستجيب اللاعب داخل Flame بتغيير منطق إطلاق النار (Strategy Pattern).

---
⬅️ **العودة إلى لوحة التحكم:** [[00_Dashboard.md.md|لوحة التحكم الرئيسية]]
