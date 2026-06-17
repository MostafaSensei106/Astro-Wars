# 🔒 الأمان وتدفق المصادقة (Security & Auth Flow)

## 🛡️ استراتيجية الحماية (Anti-Cheat & Security)

في ألعاب الموبايل (خاصة الـ Action RPG)، اللاعبون قد يستخدمون برامج مثل Memory Editors (مثل GameGuardian) لتعديل النقاط محلياً. 

### 1. التحقق من صحة الجلسة (Session Validation)
* كل لاعب يجب أن يتصل بالخادم ويحصل على **JWT (JSON Web Token)**.
* الرمز تنتهي صلاحيته دورياً ويجب تجديده (Refresh Token) لضمان أن اللاعب مسجل دخول فعلي.

### 2. حماية تدفق البيانات (Payload Integrity)
* إرسال النقاط (Commits) في نهاية اللعبة لا يعتمد على إرسال الرقم فحسب.
* **الـ Checksum:** العميل يرسل `hash(commits + duration + secret_salt)`. الخادم يمتلك نفس الـ Salt ويعيد حساب الـ Hash. إذا اختلفا، يتم رفض الطلب (Anti-cheat).
* **Validation Rules:** لا يمكن للاعب أن يجمع 10,000 نقطة في 5 ثوانٍ. السيرفر لديه (Thresholds) منطقية لسرعة تجميع النقاط.

### 3. تخزين محلي آمن (Secure Local Storage)
* أي بيانات حساسة (مثل الـ Tokens) يتم تخزينها باستخدام `flutter_secure_storage` لتشفيرها على مستوى نظام التشغيل (Keystore/Keychain).

---
⬅️ **العودة إلى لوحة التحكم:** [[00_Dashboard.md.md|لوحة التحكم الرئيسية]]
