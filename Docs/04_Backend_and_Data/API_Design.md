# 🔌 تصميم الواجهات البرمجية (API Design)

## 🌐 Endpoints الرئيسية

### 1. مصادقة وتسجيل اللاعب (Authentication & User Profile)
* `POST /api/v1/auth/login`
  * **Payload:** 
    ```json
    {
      "username": "user123",
      "password": "user_password"
    }
    ```
  * **Response:** `JWT Token` مع بيانات الـ Profile (الكلية، القسم، التراك، الرول والتاريخ):
    ```json
    {
      "token": "ey...",
      "user": {
        "id": "uuid",
        "full_name": "Ahmed Ali",
        "college": "Computers and Information",
        "department": "CS",
        "academic_year": "الفرقة الثالثة",
        "gdg_track": "Flutter",
        "system_role": "Player",
        "community_role": "Core Team",
        "community_history": [
          {"role": "Member", "year": "2024"},
          {"role": "Participant", "year": "2023"}
        ],
        "total_commits": 1500
      }
    }
    ```
* `POST /api/v1/auth/register`
  * **Payload:** إرسال بيانات المستخدم كاملة (الاسم، الباسورد، الكلية، القسم، التراك، وغيرها).

### 2. المزامنة (Syncing Game State)
* `POST /api/v1/run/sync`
  * **الوصف:** إرسال نتيجة الرنة (Run) بعد نهايتها.
  * **Payload:** المشفر بـ JWT.
    ```json
    {
      "run_id": "uuid",
      "commits_earned": 150,
      "duration_seconds": 320,
      "cause_of_death": "StackOverflow Boss",
      "checksum": "hash_for_anti_cheat"
    }
    ```
  * **Response:** `200 OK` (مع الحالة الجديدة للاعب من الـ Hub).

### 3. لوحة الصدارة (Leaderboard)
* `GET /api/v1/leaderboard/top`
  * **الوصف:** جلب أعلى 100 لاعب من الـ Redis Cache.
  * **Query Params:** `limit=100`, `season=1`

### 4. الترقيات (Upgrades)
* `POST /api/v1/meta/upgrade`
  * **الوصف:** شراء ترقية جديدة في الـ Hub.
  * **Payload:** `upgrade_id`
  * **Response:** نجاح العملية والرصيد المتبقي من الـ Commits.

---
⬅️ **العودة إلى لوحة التحكم:** [[00_Dashboard.md.md|لوحة التحكم الرئيسية]]
