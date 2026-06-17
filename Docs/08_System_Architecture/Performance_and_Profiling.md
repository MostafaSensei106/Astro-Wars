# 🚀 الأداء وتحسين الموارد (Performance & Profiling)

في ألعاب الـ Bullet Hell والـ Action Rogue-lite حيث تكثر الأجسام (Bullets/Enemies) على الشاشة، الأداء هو كل شيء:

1. **Object Pooling في Flame:**
   * بدلاً من إنشاء وتدمير الـ `BulletComponent` مع كل طلقة (مما يرهق الـ Garbage Collector)، سيتم عمل مسبح للأشياء (Pool). الطلقة التي تخرج من الشاشة أو تصطدم يتم إخفاؤها (Deactivated) وإعادة تدويرها.

2. **تقليل الاعتماد على الـ UI Threads:**
   * تحديثات واجهة المستخدم (مثل تغيير الـ Score) يجب ألا تحدث في كل Frame (60FPS). سيتم عمل Throttling لتحديث الـ Flutter HUD للتقليل من الـ Rebuilds.


---
⬅️ **العودة إلى لوحة التحكم:** [[00_Dashboard.md.md|لوحة التحكم الرئيسية]]
