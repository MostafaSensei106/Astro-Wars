# 🚀 الأداء وتحسين الموارد (Performance & Profiling)

في ألعاب الـ Bullet Hell والـ Action Rogue-lite حيث تكثر الأجسام (Bullets/Enemies) على الشاشة، الأداء هو كل شيء:

## 1. محرك اللعبة (Flame Optimizations)
* **Object Pooling:**
  بدلاً من إنشاء وتدمير الـ `BulletComponent` مع كل طلقة (مما يرهق الـ Garbage Collector)، سيتم عمل مسبح للأشياء (Pool). الطلقة التي تخرج من الشاشة أو تصطدم يتم إخفاؤها (Deactivated) وإعادة تدويرها.
* **Collision Detection:**
  استخدام خوارزميات فحص التصادم المكاني (Spatial Hash Grid أو Quadtree) إذا زاد عدد الأعداء بشكل ضخم لمنع التعقيد $O(N^2)$.

## 2. واجهة المستخدم (Flutter UI Threads)
* **Throttling Updates:**
  تحديثات واجهة المستخدم (مثل تغيير الـ Score) يجب ألا تحدث في كل Frame (60FPS). سيتم عمل Throttling لتحديث الـ Flutter HUD للتقليل من الـ Rebuilds الباهظة.
* **Repaint Boundaries:**
  عزل الأجزاء الثابتة من الشاشة عن الأجزاء المتحركة باستخدام `RepaintBoundary` لتقليل مساحة إعادة الرسم (Rasterization).

---
⬅️ **العودة إلى لوحة التحكم:** [[00_Dashboard.md.md|لوحة التحكم الرئيسية]]
