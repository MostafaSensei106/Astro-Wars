# 🗄️ مخطط قواعد البيانات (Database ERD)

## 📊 الكيانات والعلاقات

جداول مقترحة للـ PostgreSQL للتعامل مع تقدم اللاعبين:

```mermaid
erDiagram
    USERS ||--o{ RUNS : "has history of"
    USERS ||--o{ UPGRADES : "owns"
    USERS ||--o{ SPACECRAFTS : "pilots"
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
        int commits_earned "السكور الأساسي"
        int duration_seconds "زمن المحاولة بالثواني"
        string cause_of_death "سبب الخسارة (مثلا: IndexOutOfBound)"
        string stage_reached "وصل لأي بيئة (Localhost/Staging/Production)"
        int bugs_squashed "عدد البقز/الأعداء المدمرة"
        int bosses_defeated "عدد الزعماء المدمرين"
        int max_flow_state "أطول كومبو (سلسلة ضربات متتالية)"
        float accuracy "دقة التصويب"
        int coffee_cups "عدد أكواب القهوة (المساعدات) المجمعة"
        timestamp run_date
    }

    UPGRADES {
        uuid id PK
        uuid user_id FK
        string upgrade_type "نوع الترقية (مثل: CPU, RAM)"
        int current_level
    }

    SPACECRAFTS {
        uuid id PK
        uuid user_id FK
        string name "اسم المركبة (مثلا: Vim Fighter)"
        string rarity "الندرة (مثلا: Common, Epic)"
        int level "مستوى المركبة الحالي"
        boolean is_equipped "هل هي المجهزة حاليا؟"
        timestamp unlocked_at "تاريخ فتحها/شرائها"
    }
```

### 🗃️ التفاصيل الإضافية (Caching)
* **Leaderboard View:** سيتم الاعتماد على Redis (`ZSET`) لحفظ الترتيب العام المباشر بناءً على الـ `total_commits` لضمان استرجاع قائمة الأوائل بسرعة فائقة `O(log(N))`.
* سيتم تحديث الـ Leaderboard بشكل غير متزامن (Asynchronous) لتخفيف العبء عن الـ Database.

---
⬅️ **العودة إلى لوحة التحكم:** [[00_Dashboard.md.md|لوحة التحكم الرئيسية]]
