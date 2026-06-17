# 🗄️ مخطط قواعد البيانات (Database ERD)

## 📊 الكيانات والعلاقات

جداول مقترحة للـ PostgreSQL للتعامل مع تقدم اللاعبين:

```mermaid
erDiagram
    USERS ||--o{ RUNS : "has history of"
    USERS ||--o{ UPGRADES : "owns"
    USERS ||--o{ COMMUNITY_HISTORY : "has roles in"
    
    USERS {
        uuid id PK
        string full_name "الاسم"
        string username "اسم المستخدم"
        string password_hash "كلمة المرور المشفرة"
        string college "الكلية"
        string department "القسم"
        string academic_year "الصف الدراسي"
        string gdg_track "التراك في GDG"
        string system_role "الرول في السيستم (مثلا Player, Admin)"
        string community_role "الرول الحالي في الكوميونتي (مثلا Core Team)"
        int total_commits "إجمالي النقاط"
        timestamp created_at
        timestamp last_login
    }

    COMMUNITY_HISTORY {
        uuid id PK
        uuid user_id FK
        string past_role "الدور السابق (مثلا Member)"
        string season_or_year "السنة/الموسم"
    }

    RUNS {
        uuid id PK
        uuid user_id FK
        int commits_earned
        int duration_seconds
        string cause_of_death "السبب (مثلاً: NullPointerException Enemy)"
        timestamp run_date
    }

    UPGRADES {
        uuid id PK
        uuid user_id FK
        string upgrade_type "نوع الترقية (مثل: CPU, RAM)"
        int current_level
    }
```

### 🗃️ التفاصيل الإضافية (Caching)
* **Leaderboard View:** سيتم الاعتماد على Redis (`ZSET`) لحفظ الترتيب العام المباشر بناءً على الـ `total_commits` لضمان استرجاع قائمة الأوائل بسرعة فائقة `O(log(N))`.
* سيتم تحديث الـ Leaderboard بشكل غير متزامن (Asynchronous) لتخفيف العبء عن الـ Database.

---
⬅️ **العودة إلى لوحة التحكم:** [[00_Dashboard.md.md|لوحة التحكم الرئيسية]]
