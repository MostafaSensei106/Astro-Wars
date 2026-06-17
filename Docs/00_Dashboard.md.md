# 🚀 GDGOC: Astro Wars - Project Dashboard

> "Talk is cheap. Show me the code." - Linus Torvalds

**فلسفة المشروع:** 
لعبة Action RPG / Rogue-lite موجهة لمجتمع المطورين والطلاب. تركز اللعبة على التحديات الحقيقية، وتقدم نقداً كوميدياً ساخراً لكل من التيك انفلونسر الهبادين و الجامعات و حياة الطلاب و المطورين بشكل عام. تعتمد اللعبة تقنياً على المعمارية النظيفة، وتحترم عقلية اللاعب من خلال تجربة لعب مصقولة وأداء عالي الجودة.

---

## 📊 نظرة عامة تقنية (Tech Stack)
* **المحرك:** Flutter & Flame Engine.
* **إدارة الحالة:** BLoC / Cubit.
* **الباك إند:** Go lang gin + PostgreSQL.
* **إدارة البيانات المؤقتة:** mem .
* **المنصة المستهدفة:** Mobile  .

---

## 🗂️ الفهرس الرئيسي (Main Directory)
*(ملاحظة: اضغط على أي رابط لإنشاء الملف الخاص به فوراً)*

### 📐 1. هيكلة النظام (System Architecture)
* [[High_Level_Design]] - المخطط العام وربط واجهة المستخدم بالخوادم.
* [[Frontend_Architecture]] - تطبيق Clean Architecture وفصل الطبقات (Domain, Data, Presentation).
* [[Backend_Architecture]] - تصميم الـ APIs وتدفق البيانات.
* [[Database_ERD]] - هيكلة جداول المستخدمين، الـ XP، وترتيب اللاعبين.
* [[Performance_and_Profiling]] - استراتيجيات الـ Micro-optimization والتعامل مع الذاكرة.

### 🎮 2. تصميم اللعبة (Game Design Document)
* [[Game_Core_Loop]] - ميكانيكا اللعب الأساسية، دورة التقدم، وتطوير الأسلحة.
* [[World_Building_and_Lore]] - عالم "السيليكون" والصراع مع الإمبراطورية القمعية.
* [[Characters_Roster]] - الشخصيات القابلة للعب (Astro, Byte, Cipher, Pixel) ومميزاتها.
* [[Bosses_and_Enemies]] - آليات قتال الزعماء (Boss Mechanics) وأنماط الهجوم.

### 🎨 3. التوجه الفني (Art & Audio)
* [[Art_Direction]] - لوحة الألوان الأساسية وقواعد تصميم الواجهات (UI/UX).
* [[VFX_and_Animations]] - المؤثرات البصرية للأسلحة وانفجارات الأعداء.

### 📢 4. المجتمع والتسويق (Community & Engagement)
* [[Leaderboard_System]] - ربط اللعبة بنشاطات الكوميونتي وتوزيع الجوائز.
* [[Easter_Eggs]] - رسائل مخفية، نكت برمجية، وتلميحات داخل اللعبة.

### 🛠️ 5. إدارة المشروع (Project Management)
* [[Current_Sprint]] - المهام المجدولة للنسخة الحالية.
* [[Bugs_and_Fixes]] - تتبع المشاكل التقنية وتصحيحها.

---

## 📌 مهام قيد التنفيذ (Active To-Do)
- [ ] إعداد الملفات الأساسية المذكورة في الفهرس.
- [ ] كتابة الـ Game Core Loop وتحديد مسار تقدم اللاعب.
- [ ] رسم الـ ERD المبدئي للباك إند.
- [ ] تهيئة مشروع Flutter وتركيب مكتبات Flame و BLoC.